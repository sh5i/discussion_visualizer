json.extract! issue_relation, :id, :issue_id, :target_issue_title, :target_issue_name, :type_text, :created_at, :updated_at
json.url issue_relation_url(issue_relation, format: :json)
