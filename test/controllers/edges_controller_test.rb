require 'test_helper'

class EdgesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edge = edges(:one)
  end

  test "should get index" do
    get edges_url
    assert_response :success
  end

  test "should get new" do
    get new_edge_url
    assert_response :success
  end

  test "should create edge" do
    assert_difference('Edge.count') do
      post edges_url, params: { edge: {  } }
    end

    assert_redirected_to edge_url(Edge.last)
  end

  test "should show edge" do
    get edge_url(@edge)
    assert_response :success
  end

  test "should get edit" do
    get edit_edge_url(@edge)
    assert_response :success
  end

  test "should update edge" do
    patch edge_url(@edge), params: { edge: {  } }
    assert_redirected_to edge_url(@edge)
  end

  test "should destroy edge" do
    assert_difference('Edge.count', -1) do
      delete edge_url(@edge)
    end

    assert_redirected_to edges_url
  end
end
