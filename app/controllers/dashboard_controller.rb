class DashboardController < ApplicationController
  def home
  end

  def upload_file
    uploaded = import_params[:file]
    import = PropertyImportService.call(uploaded)
    redirect_to import_import_rows_path(import)
  end

  private
  def import_params
    params.expect(import: [ :file, :model ])
  end
end
