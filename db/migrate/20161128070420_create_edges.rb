class CreateEdges < ActiveRecord::Migration[5.0]
  def change
    create_table :edges do |t|
      t.references  :user
      t.references  :comment
      t.integer     :to_comment_id, :null => false
      t.string      :type_text
      t.timestamps
    end
    add_foreign_key :edges, :comments, on_delete: :cascade, on_update: :cascade

    add_index :edges, :to_comment_id
  end
end
