class CreatePatchAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :patch_authors do |t|
      t.string :name

      t.timestamps
    end
  end
end
