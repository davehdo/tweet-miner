require "exception_notify_block.rb"
extend ExceptionNotifyBlock


namespace :exchange_rates do
  # desc "TODO"
  task :recent_or_fetch => :environment do
    exception_notify do
      ExchangeRate.recent_or_fetch
    end
  end

end