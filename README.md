# README

# Introduction

This is a Ruby on Rails application made to assist with onboarding new Payscore customers by allowing customers' Property and Unit data to be imported from a .csv file.

# Installation
1. Clone the git repository to a directory of your choosing
2. `cd property-importer` and run `bin/setup`
3. Open the app at http://localhost:3000
4. If the server must be restarted after running `bin/setup`, be sure to use `bin/dev`

# Assumptions
- Since the Customer relation is not included as part of this assessment, all properties are assumed to belong to a single customer currently being onboarded; Property names are therefore required to be unique at the database level, though in reality this uniqueness constraint would be scoped to the owning Customer
- A Property with no units is valid and represents a single family home rather than an apartment complex
- Customer-provided .csv files will always have the schema of the provided example file despite coming from potentially many property management systems. Support for different .csv schemas could easily be added through more variations of ImportFromCsvService
- Properties will always have different building names
- Properties will always have different street addresses

# Tradeoffs
- .csv files are parsed in-memory rather than streamed or batched, which will not scale well for very large files
- Concurrency concerns (e.g. multiple imports committing simultaneously) are not accounted for

# Architecture and Design Choices
In addition to Properties and Units, this app makes use of two models and three service objects. General flow of data is as follows:

CSV -> Import -> Data Normalization -> ImportRows -> Validation -> Commit -> Properties and Units in the DB

## ImportRow
- Represents a single row of the raw CSV file.
- Does not have any validations but does perform some normalization on imported data. (Namely trimming whitespace, upcasing)

## Import
- Represents a group of ImportRows imported from a single .csv file
- Records the file name of the .csv from which it was generated
- Records whether the ImportValidationService has validated all of its ImportRows and is ready to be committed to the DB
- Records whether it has already been committed to the DB to avoid attempting to save duplicate data. (Although DB constraints on Property and Unit do prevent that anyway)

Import and ImportRow are persisted to allow users to verify imported data and perform validation before fully committing to the DB.

## ImportFromCsvService
- Creates an Import object to associate with the current .csv file
- Parses .csv rows and creates ImportRow objects, attaching them to the Import object

## ImportValidationService
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

## ImportCommitService
- Responsible for parsing data associated with an Import into individual Properties and Units for committing to the DB transactionally
- Will refuse to commit Imports that have not been validated by ImportValidationService
- Will refuse to commit Imports that have passed validation but have already been committed before

