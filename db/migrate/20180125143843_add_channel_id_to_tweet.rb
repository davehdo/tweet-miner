class AddChannelIdToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :channel_id, :integer
  end
end
