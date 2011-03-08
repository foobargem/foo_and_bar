require 'test_helper'

class Admin::CarsControllerTest < ActionController::TestCase
  setup do
    @admin_car = admin_cars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_cars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_car" do
    assert_difference('Admin::Car.count') do
      post :create, :admin_car => @admin_car.attributes
    end

    assert_redirected_to admin_car_path(assigns(:admin_car))
  end

  test "should show admin_car" do
    get :show, :id => @admin_car.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_car.to_param
    assert_response :success
  end

  test "should update admin_car" do
    put :update, :id => @admin_car.to_param, :admin_car => @admin_car.attributes
    assert_redirected_to admin_car_path(assigns(:admin_car))
  end

  test "should destroy admin_car" do
    assert_difference('Admin::Car.count', -1) do
      delete :destroy, :id => @admin_car.to_param
    end

    assert_redirected_to admin_cars_path
  end
end
