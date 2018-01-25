class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|
      t.string :keyword
      t.string :name
      t.timestamps
    end
  end
end
