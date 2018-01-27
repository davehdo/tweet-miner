class AddActiveToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :active, :boolean
    add_column :channels, :symbol, :string
  end
end
