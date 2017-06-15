require 'test_helper'

class IssueRelationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue_relation = issue_relations(:one)
  end

  test "should get index" do
    get issue_relations_url
    assert_response :success
  end

  test "should get new" do
    get new_issue_relation_url
    assert_response :success
  end

  test "should create issue_relation" do
    assert_difference('IssueRelation.count') do
      post issue_relations_url, params: { issue_relation: { issue_id: @issue_relation.issue_id, target_issue_name: @issue_relation.target_issue_name, target_issue_title: @issue_relation.target_issue_title, type_text: @issue_relation.type_text } }
    end

    assert_redirected_to issue_relation_url(IssueRelation.last)
  end

  test "should show issue_relation" do
    get issue_relation_url(@issue_relation)
    assert_response :success
  end

  test "should get edit" do
    get edit_issue_relation_url(@issue_relation)
    assert_response :success
  end

  test "should update issue_relation" do
    patch issue_relation_url(@issue_relation), params: { issue_relation: { issue_id: @issue_relation.issue_id, target_issue_name: @issue_relation.target_issue_name, target_issue_title: @issue_relation.target_issue_title, type_text: @issue_relation.type_text } }
    assert_redirected_to issue_relation_url(@issue_relation)
  end

  test "should destroy issue_relation" do
    assert_difference('IssueRelation.count', -1) do
      delete issue_relation_url(@issue_relation)
    end

    assert_redirected_to issue_relations_url
  end
end
