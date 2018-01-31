namespace :tweets do

  task :resave_all => :environment do
    Tweet.all.each(&:save)
  end

end