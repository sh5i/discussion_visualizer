class AddColumnsToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :name, :string
    add_reference :issues, :project
    add_reference :issues, :user
    add_column :issues, :status_type, :string

    add_foreign_key :issues, :projects, on_delete: :cascade, on_update: :cascade
    add_foreign_key :issues, :users, on_delete: :nullify, on_update: :nullify
  end
end
