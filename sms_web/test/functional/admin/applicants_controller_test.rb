require 'test_helper'

class Admin::ApplicantsControllerTest < ActionController::TestCase
  setup do
    @admin_applicant = admin_applicants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_applicants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_applicant" do
    assert_difference('Admin::Applicant.count') do
      post :create, :admin_applicant => @admin_applicant.attributes
    end

    assert_redirected_to admin_applicant_path(assigns(:admin_applicant))
  end

  test "should show admin_applicant" do
    get :show, :id => @admin_applicant.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_applicant.to_param
    assert_response :success
  end

  test "should update admin_applicant" do
    put :update, :id => @admin_applicant.to_param, :admin_applicant => @admin_applicant.attributes
    assert_redirected_to admin_applicant_path(assigns(:admin_applicant))
  end

  test "should destroy admin_applicant" do
    assert_difference('Admin::Applicant.count', -1) do
      delete :destroy, :id => @admin_applicant.to_param
    end

    assert_redirected_to admin_applicants_path
  end
end
