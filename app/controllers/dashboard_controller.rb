class DashboardController < ApplicationController
  def home
  end

  def upload_file
    uploaded = import_params[:file]
    PropertyImportService.call(uploaded)
  end

  private
  def import_params
    params.expect(import: [ :file, :model ])
  end
end
