class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.references :user
      t.string     :controller_name
      t.string     :action_name
      t.datetime   :actioned_at
    end
    add_foreign_key :logs, :users, on_delete: :cascade, on_update: :cascade
  end
end
