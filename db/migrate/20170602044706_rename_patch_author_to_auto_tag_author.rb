class RenamePatchAuthorToAutoTagAuthor < ActiveRecord::Migration[5.0]
  def change
    rename_table :patch_authors, :auto_tag_authors
  end
end
