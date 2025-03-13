require "test_helper"

class Admin::FeaturedListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_featured_listings_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_featured_listings_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_featured_listings_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_featured_listings_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_featured_listings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_featured_listings_destroy_url
    assert_response :success
  end
end
