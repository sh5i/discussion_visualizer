class AddColumnsToAutoTagAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :auto_tag_authors, :tag_content, :string
    add_reference :auto_tag_authors, :project

    add_foreign_key :auto_tag_authors, :projects, on_delete: :cascade, on_update: :cascade
  end
end
