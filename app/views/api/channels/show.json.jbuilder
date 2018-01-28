json.extract! @channel, :id, :symbol, :keyword, :created_at, :updated_at

@tweets = @channel.tweets.select("statistics_json, created_at").order("created_at DESC")

json.features @tweets.collect do |tweet|
  # find the query that was 6 hours ago (plus or minus 10 minutes)

  
  # allowing values up to 30 minutes old for assignment
  value_t_6 = ExchangeRate.recent_price_of(@channel.symbol, tweet.created_at + 6.hours, 30.minutes)
  value_t_0 = ExchangeRate.recent_price_of(@channel.symbol, tweet.created_at, 30.minutes)

  
  json.timestamp tweet.created_at
  json.predictors do
    json.hour_of_day tweet.created_at.utc.hour
    json.day_of_week tweet.created_at.utc.wday
    json.t_0 tweet.statistics
    
    # for select features at select timepoints, include the fraction changed
    [24, 48, 72].each do |hrs|
      # going backward, find the first one that was before specific time
      prior_tweet = @tweets.find {|t| t.created_at < tweet.created_at - hrs.hours }
    
      if prior_tweet
        ["unique_tweets_per_hour"].each do |feature|
          json.set! "#{feature}_#{hrs}h_frac_change", ((tweet.statistics[feature] - prior_tweet.statistics[feature]).to_f / prior_tweet.statistics[feature])
        end
      end
    end
  end
  
  json.outcomes( {
    value_t_0: value_t_0,
    value_t_6: value_t_6,
    relative_value_t_6: (value_t_0 and value_t_6) ? (1.0 * value_t_6 / value_t_0) : nil,
    frac_change_t_6: (value_t_0 and value_t_6) ? ( (value_t_6 - value_t_0).to_f / value_t_0) : nil
  })
end