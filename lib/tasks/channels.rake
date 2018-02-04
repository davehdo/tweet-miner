namespace :channels do
  def exception_notify
    yield
  rescue Exception => exception
    env = {}
    env['exception_notifier.options'] = { 
      :email_prefix => '[Exception] ',
      :sender_address => '"R2D2" <noreply@skroutz.gr>',
      :exception_recipients => 'dev@skroutz.gr',
      :sections => [ 'backtrace']
    }
    ExceptionNotifier::Notifier.exception_notification(env, exception).deliver
    raise exception
  end
  
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

  task :test => :environment do
    Channel.test_exception
  end
  
  task :test_2 => :environment do 
    exception_notify do
      1 / 0
    end
  end
end