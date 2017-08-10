class AddAutoTagAuthorToTags < ActiveRecord::Migration[5.0]
  def change
    add_reference :tags, :auto_tag_author

    add_foreign_key :tags, :auto_tag_authors, on_delete: :cascade, on_update: :cascade
  end
end
