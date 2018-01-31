class AddIndexToExchangeRate < ActiveRecord::Migration[5.1]
  def change
    add_index :exchange_rates, :created_at
  end
end
