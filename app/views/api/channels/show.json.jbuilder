json.extract! @channel, :id, :symbol, :keyword, :created_at, :updated_at

@tweets = @channel.tweets.select("statistics_json, created_at").order("created_at ASC")

json.features @tweets.collect do |tweet|
  # find the query that was 6 hours ago (plus or minus 10 minutes)

  
  # allowing values up to 30 minutes old for assignment
  value_t_6 = ExchangeRate.recent_price_of(@channel.symbol, tweet.created_at + 6.hours, 30.minutes)
  value_t_0 = ExchangeRate.recent_price_of(@channel.symbol, tweet.created_at, 30.minutes)
  
  json.timestamp tweet.created_at
  json.predictors({ 
    hour_of_day: tweet.created_at.utc.hour,
    t_0: tweet.statistics
  })
  json.outcomes( {
    value_t_0: value_t_0,
    value_t_6: value_t_6,
    relative_value_t_6: (value_t_0 and value_t_6) ? (1.0 * value_t_6 / value_t_0) : nil
  })
end