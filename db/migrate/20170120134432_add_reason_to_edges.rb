class AddReasonToEdges < ActiveRecord::Migration[5.0]
  def change
    add_column :edges, :reason, :string
  end
end
