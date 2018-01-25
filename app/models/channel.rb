class Channel < ApplicationRecord
  has_many :tweets
  
  def rerun_query
    if self.keyword.present?

      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
      
      tweets = client.search(self.keyword, result_type: "recent", count: 100).collect do |tweet|
        # puts tweet.favorite_count
        # puts tweet.retweet_count
        # puts tweet.full_text
        # puts tweet    e.g.  <Twitter::Tweet:0x007f9ef54c4f78>
        # puts tweet.to_json # {...}

        tweet
      end
      
      self.tweets.create( keyword: self.keyword, unique_id:  nil, full_json: tweets.to_json)
    end
  end
end
