# because rake tasks don't trigger exception notification by default
# wrap items with a exception_notify block
# to use, at the top of the rake task, add these two lines:
# require "exception_notify_block.rb"
# extend ExceptionNotifyBlock


module ExceptionNotifyBlock
  
  def exception_notify
    yield
  rescue Exception => exception
    env = {}
    env['exception_notifier.options'] = { 
      :email_prefix => "[CRYPTOCURRENCY] ",
      :sender_address => %{"notifier" <notifier@example.com>},
      :exception_recipients => ENV["EXCEPTION_RECIPIENTS"].split(","),
      :sections => [ 'backtrace']
    }
    ExceptionNotifier::Notifier.exception_notification(env, exception).deliver
    raise exception
  end 
end
  