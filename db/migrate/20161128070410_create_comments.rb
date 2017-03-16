class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references  :issue
      t.string      :author
      t.text        :content
      t.string      :type_text
      t.string      :jira_id
      t.integer     :internal_id
      t.timestamps
    end
    add_foreign_key :comments, :issues, on_delete: :cascade, on_update: :cascade
  end
end
