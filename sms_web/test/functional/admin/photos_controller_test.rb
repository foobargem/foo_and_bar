require 'test_helper'

class Admin::PhotosControllerTest < ActionController::TestCase
  setup do
    @admin_photo = admin_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_photo" do
    assert_difference('Admin::Photo.count') do
      post :create, :admin_photo => @admin_photo.attributes
    end

    assert_redirected_to admin_photo_path(assigns(:admin_photo))
  end

  test "should show admin_photo" do
    get :show, :id => @admin_photo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_photo.to_param
    assert_response :success
  end

  test "should update admin_photo" do
    put :update, :id => @admin_photo.to_param, :admin_photo => @admin_photo.attributes
    assert_redirected_to admin_photo_path(assigns(:admin_photo))
  end

  test "should destroy admin_photo" do
    assert_difference('Admin::Photo.count', -1) do
      delete :destroy, :id => @admin_photo.to_param
    end

    assert_redirected_to admin_photos_path
  end
end
