class CreateIssueRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :issue_relations do |t|
      t.references :issue
      t.string :target_issue_title
      t.string :target_issue_name
      t.string :type_text

      t.timestamps
    end
    add_foreign_key :issue_relations, :issues, on_delete: :cascade, on_update: :cascade
  end
end
