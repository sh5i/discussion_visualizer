class CreateBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :bookmarks do |t|
      t.references :user
      t.references :comment

      t.timestamps
    end
  end
end
