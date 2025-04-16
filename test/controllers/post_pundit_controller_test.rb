require "test_helper"

class PostPunditControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get post_pundit_index_url
    assert_response :success
  end

  test "should get show" do
    get post_pundit_show_url
    assert_response :success
  end

  test "should get edit" do
    get post_pundit_edit_url
    assert_response :success
  end

  test "should get update" do
    get post_pundit_update_url
    assert_response :success
  end

  test "should get create" do
    get post_pundit_create_url
    assert_response :success
  end

  test "should get publish" do
    get post_pundit_publish_url
    assert_response :success
  end

  test "should get admin_list" do
    get post_pundit_admin_list_url
    assert_response :success
  end
end
