require 'test_helper'

class Admin::RacingModelsControllerTest < ActionController::TestCase
  setup do
    @admin_racing_model = admin_racing_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_racing_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_racing_model" do
    assert_difference('Admin::RacingModel.count') do
      post :create, :admin_racing_model => @admin_racing_model.attributes
    end

    assert_redirected_to admin_racing_model_path(assigns(:admin_racing_model))
  end

  test "should show admin_racing_model" do
    get :show, :id => @admin_racing_model.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_racing_model.to_param
    assert_response :success
  end

  test "should update admin_racing_model" do
    put :update, :id => @admin_racing_model.to_param, :admin_racing_model => @admin_racing_model.attributes
    assert_redirected_to admin_racing_model_path(assigns(:admin_racing_model))
  end

  test "should destroy admin_racing_model" do
    assert_difference('Admin::RacingModel.count', -1) do
      delete :destroy, :id => @admin_racing_model.to_param
    end

    assert_redirected_to admin_racing_models_path
  end
end
