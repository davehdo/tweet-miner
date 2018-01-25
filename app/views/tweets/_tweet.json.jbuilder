json.extract! tweet, :id, :keyword, :unique_id, :full_json, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
