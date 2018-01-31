class AddIndexToTweet < ActiveRecord::Migration[5.1]
  def change
    add_index :tweets, :channel_id
    add_index :tweets, [:channel_id, :created_at]
    
  end
end
