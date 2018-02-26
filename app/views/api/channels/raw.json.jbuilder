json.extract! @channel, :id, :symbol, :keyword, :created_at, :updated_at


json.snapshots @channel.tweets.collect do |tweet|
  # find the query that was 6 hours ago (plus or minus 10 minutes)
  json.snapshot_at tweet.created_at
  json.price ExchangeRate.recent_price_of(@channel.symbol, tweet.created_at, 30.minutes)
  json.tweets tweet.full_json
end