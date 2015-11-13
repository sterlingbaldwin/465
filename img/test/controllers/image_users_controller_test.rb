require 'test_helper'

class ImageUsersControllerTest < ActionController::TestCase
  setup do
    @image_user = image_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_user" do
    assert_difference('ImageUser.count') do
      post :create, image_user: { image_id: @image_user.image_id, user_id: @image_user.user_id }
    end

    assert_redirected_to image_user_path(assigns(:image_user))
  end

  test "should show image_user" do
    get :show, id: @image_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image_user
    assert_response :success
  end

  test "should update image_user" do
    patch :update, id: @image_user, image_user: { image_id: @image_user.image_id, user_id: @image_user.user_id }
    assert_redirected_to image_user_path(assigns(:image_user))
  end

  test "should destroy image_user" do
    assert_difference('ImageUser.count', -1) do
      delete :destroy, id: @image_user
    end

    assert_redirected_to image_users_path
  end
end
