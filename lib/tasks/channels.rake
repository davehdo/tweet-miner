namespace :channels do

  task :fetch_all => :environment do
    Channel.where(active: true).each do |channel|
      puts "#{ channel.name }: "
      if channel.last_query and channel.last_query.created_at > Time.now - 10.minutes
        puts "  there was a recent query for this channel"# there was a recent
      else
        channel.rerun_query
      end
    end
  end

end