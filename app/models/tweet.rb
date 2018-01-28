# originally named tweet, this is probably more appropriately named "queries"

class Tweet < ApplicationRecord
  belongs_to :channel
  before_save :update_statistics
  
  
  def parsed_json
    @parsed_json ||= JSON.parse(self.full_json)
  end
   
  def unique_tweets_per_hour
    (1.0 * n_unique_tweets / time_span).round
  end
  
  def n_unique_tweets
    parsed_json.uniq {|e| e["text"].gsub(/\d/, "0").gsub(/^RT @.*?: /, "")}.size  
  end
  
  def time_span
    earliest_at = Time.parse( parsed_json.last["created_at"] )
    latest_at = Time.parse( parsed_json.first["created_at"] )
    (latest_at - earliest_at) / 1.hour
  end
  
  def statistics
    a = read_attribute(:statistics_json)
    a == nil ? nil : JSON.parse(a)
  end
  
  def statistics=( obj )
    write_attribute(:statistics_json, obj.to_json )
  end
  
  private
  
  def update_statistics
    self.statistics = {
      "unique_tweets_per_hour" => self.unique_tweets_per_hour
    }
  end
end
