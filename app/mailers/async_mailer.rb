module AsyncMailer

  module Mailer
    def async
      Proxy.new(self)
    end
  end

  class Proxy
    def initialize(mailer_class)
      @mailer_class = mailer_class
    end

    def method_missing(method, *args)
      if Rails.env.test?
        @mailer_class.send(method, *args).deliver
      else
        Resque.enqueue(Worker, @mailer_class.name, method, *args)
      end
    end
  end

  class Worker
    @queue = :mailer

    def self.perform(class_name, method, *args)
      class_name.constantize.send(method, *args).deliver
    end
  end
end
