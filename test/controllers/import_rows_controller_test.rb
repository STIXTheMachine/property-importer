require "test_helper"

class ImportRowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @import_row = import_rows(:one)
  end

  test "should get index" do
    get import_rows_url
    assert_response :success
  end

  test "should get new" do
    get new_import_row_url
    assert_response :success
  end

  test "should create import_row" do
    assert_difference("ImportRow.count") do
      post import_rows_url, params: { import_row: { building_name: @import_row.building_name, city: @import_row.city, import_id: @import_row.import_id, state: @import_row.state, street_address: @import_row.street_address, unit: @import_row.unit, zip: @import_row.zip } }
    end

    assert_redirected_to import_row_url(ImportRow.last)
  end

  test "should show import_row" do
    get import_row_url(@import_row)
    assert_response :success
  end

  test "should get edit" do
    get edit_import_row_url(@import_row)
    assert_response :success
  end

  test "should update import_row" do
    patch import_row_url(@import_row), params: { import_row: { building_name: @import_row.building_name, city: @import_row.city, import_id: @import_row.import_id, state: @import_row.state, street_address: @import_row.street_address, unit: @import_row.unit, zip: @import_row.zip } }
    assert_redirected_to import_row_url(@import_row)
  end

  test "should destroy import_row" do
    assert_difference("ImportRow.count", -1) do
      delete import_row_url(@import_row)
    end

    assert_redirected_to import_rows_url
  end
end
