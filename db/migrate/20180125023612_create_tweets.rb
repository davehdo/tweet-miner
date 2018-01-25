class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :keyword
      t.string :unique_id
      t.text :full_json

      t.timestamps
    end
  end
end
