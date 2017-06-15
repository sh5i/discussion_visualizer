class RenameNameColumnToAutoTagAuthors < ActiveRecord::Migration[5.0]
  def change
    rename_column :auto_tag_authors, :name, :author_name
  end
end
