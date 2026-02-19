# README

# Introduction

This is a Ruby on Rails application made to assist with onboarding new Payscore customers by implementing an Upload, Review, Edit, Commit pipeline for Property and Unit data ingestion.

# Installation
1. Clone the git repository to a directory of your choosing
2. `cd property-importer` and run `bin/setup` (this will also start the server)
3. Open the app at http://localhost:3000
4. Project uses the Procfile stack (Tailwind watcher, Rails server), so when starting the server manually be sure to use `bin/dev` and not `bin/rails s`

# Assumptions
- Since the Customer relation is not included as part of this assessment, all properties are assumed to belong to a single customer currently being onboarded; Property names are therefore required to be unique at the database level, though in reality this uniqueness constraint would be scoped to the owning Customer
- A Property with no units is valid and represents a single family home rather than an apartment complex
- Customer-provided .csv files will always have the schema of the provided example file despite coming from potentially many property management systems. Support for different .csv schemas could easily be added through more variations of ImportFromCsvService
- Properties will always have different building names
- Properties will always have different street addresses

# Tradeoffs
- .csv files are parsed in-memory rather than streamed or batched, which will not scale well for very large files
- Concurrency concerns (e.g. multiple imports committing simultaneously) are not accounted for

# Improvements for the Future
- Extract data normalization responsibility from ImportRow model into a dedicated ImportNormalizationService
- Discuss with team whether .csv imports are expected to be large enough to benefit from batch importing
- Discuss with team whether data safety under concurrency is necessary
- Consider making Import and ImportRows transient. They need to be persisted to the DB to be kept alive throughout the import pipeline, but it might not be unreasonable to delete them once an Import is committed
  - Would also require determining how to handle session abandonment
- Reorganize Property and Import views to allow for concise, table-based viewing a la Import and ImportRow
- Create a DataValidationReport PORO and a view partial to render it properly in the import screen rather than dumping errors into the flash notification
- (Stretch) Add turbo-driven features such as inline ImportRow editing, sorting/filtering ImportTables by specific columns
- (Stretch) Integrate data import features into homepage to give SPA-like UX on the happy path

# Architecture and Design Choices
In addition to Properties and Units, this app makes use of two models and three service objects. General flow of data is as follows:

User CSV -> Import -> Data Normalization -> ImportRows -> Validation -> Commit -> Properties and Units in the DB

## Models

### ImportRow
- Represents a single row of the raw CSV file.
- Does not have any validations but does perform some normalization on imported data. (Namely trimming whitespace, upcasing)

### Import
- Represents a group of ImportRows imported from a single .csv file
- Records the file name of the .csv from which it was generated
- Records whether the ImportValidationService has validated all of its ImportRows and is ready to be committed to the DB
- Records whether it has already been committed to the DB to avoid attempting to save duplicate data, though DB constraints do enforce this.

Import and ImportRow are persisted to allow users to verify imported data and perform validation before fully committing to the DB.

## Services

### ImportFromCsvService
- Creates an Import object to associate with the current .csv file
- Parses .csv rows and creates ImportRow objects, attaching them to the Import object

### ImportValidationService
- Loops over all ImportRows associated with an Import object and verifies that they are suitable for committing to the DB.
  - This logic is intentionally performed here rather than via model validations on ImportRow. The goal is to allow the user to import all CSV data into the app for review, even if something is missing or malformed. This requires extracting the validation logic out of the model level
  - Service is structured so that it is clear to see precisely what criteria are being checked and so that it is easy to add additional validation checks
- Service currently performs the following validations:
  - Checks for duplicate Properties by building name (e.g. Avenue Apartments at 123 Test St. and Avenue Apartments at 456 Test St.)
  - Checks for duplicate Properties by full address (e.g. Avenue Apartments at 123 Test St, Seattle, Washington 98122 and Adventure Apartments at 123 Test St, Seattle, Washington 98122)
  - Checks for duplicate Units within a Property
  - Ensures that all fields (except maybe Unit) are populated
  - Validates that all states have been successfully normalized to a 2-letter state code
  - Validates that all zip codes are plausible
    - True verification would involve calling an external API or maintaining an unduly large local dataset, so some simple heuristics are employed

### ImportCommitService
- Responsible for parsing data associated with an Import into individual Properties and Units for committing to the DB transactionally
- Will refuse to commit Imports that have not been validated by ImportValidationService
- Will refuse to commit Imports that have passed validation but have already been committed before

