namespace :tweets do

  task :resave => :environment do
    # each time we update the features extraction, need to resave all entries
    # which can be quite resource intensive
    # so we try to be selective about it
    puts "There are #{Tweet.where("statistics_json NOT LIKE '%followers_reached_per_hour%'").size} to resave"
    puts "  Resaving the next 100 of these"
    Tweet.where("statistics_json NOT LIKE '%followers_reached_per_hour%'").limit(100).each(&:save)
  end

  # meant to test exception notification
  task :test => :environment do
    1 / 0

  end

end