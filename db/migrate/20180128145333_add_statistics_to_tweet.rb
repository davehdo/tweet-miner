class AddStatisticsToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :statistics_json, :text
  end
end
