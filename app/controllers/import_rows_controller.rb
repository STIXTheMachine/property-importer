class ImportRowsController < ApplicationController
  before_action :set_import_row, only: %i[ show edit update destroy ]

  # GET /import_rows or /import_rows.json
  def index
    @import_rows = ImportRow.all
  end

  # GET /import_rows/1 or /import_rows/1.json
  def show
  end

  # GET /import_rows/new
  def new
    @import_row = ImportRow.new
  end

  # GET /import_rows/1/edit
  def edit
  end

  # POST /import_rows or /import_rows.json
  def create
    @import_row = ImportRow.new(import_row_params)

    respond_to do |format|
      if @import_row.save
        format.html { redirect_to @import_row, notice: "Import row was successfully created." }
        format.json { render :show, status: :created, location: @import_row }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @import_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_rows/1 or /import_rows/1.json
  def update
    respond_to do |format|
      if @import_row.update(import_row_params)
        format.html { redirect_to @import_row, notice: "Import row was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @import_row }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @import_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_rows/1 or /import_rows/1.json
  def destroy
    @import_row.destroy!

    respond_to do |format|
      format.html { redirect_to import_rows_path, notice: "Import row was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import_row
      @import_row = ImportRow.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def import_row_params
      params.expect(import_row: [ :building_name, :street_address, :unit, :city, :state, :zip, :import_id ])
    end
end
