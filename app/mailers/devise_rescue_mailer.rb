module Resque
  module Mailer
    class MessageDecoy
      def deliver
        record = @args.first        
        resque.enqueue @mailer_class, @method_name, record.class.name, record.id
      end
    end
  end
end
 
class DeviseResqueMailer < Devise::Mailer
  include Resque::Mailer
 
  def self.perform(action, class_name, id)
    record = class_name.constantize.find(id)
    self.send(:new, action, record).message.deliver
  end
end
