
# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'


ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.before(:each) do
    Disclosure.configuration.owner_class = "User"
  end

  config.before(:each) do
    class Disclosure::Issue
      def self.notifiable_actions
        ["created", "closed"]
      end

      def save
        after_commit
      end

      def closed?
        true
      end

      def after_commit
        ActiveSupport::Notifications.instrument "disclosure.model_saved", :model => self
      end

      def user_id 
        1
      end
    end

    class Disclosure::TestReactor; end
    Disclosure.configuration.notifier_classes = [Disclosure::Issue]
    Disclosure.configuration.reactor_classes = [Disclosure::TestReactor]
    Disclosure.bootstrap!
  end
end