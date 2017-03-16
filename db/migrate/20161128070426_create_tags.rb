class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references  :user
      t.references  :comment
      t.string      :content

      t.timestamps
    end
    add_foreign_key :tags, :users, on_delete: :cascade, on_update: :cascade
    add_foreign_key :tags, :comments, on_delete: :cascade, on_update: :cascade
  end
end
