require 'test_helper'

class Admin::CompaniesControllerTest < ActionController::TestCase
  setup do
    @admin_company = admin_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_company" do
    assert_difference('Admin::Company.count') do
      post :create, :admin_company => @admin_company.attributes
    end

    assert_redirected_to admin_company_path(assigns(:admin_company))
  end

  test "should show admin_company" do
    get :show, :id => @admin_company.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_company.to_param
    assert_response :success
  end

  test "should update admin_company" do
    put :update, :id => @admin_company.to_param, :admin_company => @admin_company.attributes
    assert_redirected_to admin_company_path(assigns(:admin_company))
  end

  test "should destroy admin_company" do
    assert_difference('Admin::Company.count', -1) do
      delete :destroy, :id => @admin_company.to_param
    end

    assert_redirected_to admin_companies_path
  end
end
