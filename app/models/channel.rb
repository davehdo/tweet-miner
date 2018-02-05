class Channel < ApplicationRecord
  has_many :tweets
  
  def self.test_exception
    1 / 0
  end
  
  def last_query
    tweets.order("created_at desc").limit(1)[0]; 
  end
  
  def self.client
    @client ||= Twitter::REST::Client.new do |config|
      # first two params are used in application-only authentication
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"] 
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"] 
      
      # Some resources require single-user authentication, in which case we include the following
      # config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      # config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end
  
  
  def rerun_query # twitter search API
    puts "  Fetching twitter data for #{ self.name }"
    # Requests / 15-min window (app auth)	
    if self.keyword.present?
      # go to apps.twitter.com to add an app and generate these keys and tokens
      
      tweets = Channel.client.search(self.keyword, result_type: "recent", count: 100).collect do |tweet|
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
