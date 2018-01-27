namespace :exchange_rates do
  # desc "TODO"
  task :recent_or_fetch => :environment do
    ExchangeRate.recent_or_fetch
  end

end