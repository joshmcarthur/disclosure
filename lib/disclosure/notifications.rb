module Disclosure
  module Notifications
    def self.subscribe!
      ActiveSupport::Notifications.subscribe "disclosure.model_saved" do |name, start, finish, id, payload|
        Disclosure.react_to!(payload[:model])
      end
    end

    def self.instrument!
      Disclosure.configuration.notifier_classes.each do |klass|
        klass.class_eval do
          after_commit :notify_disclosure

          private

          def notify_disclosure
            ActiveSupport::Notifications.instrument("disclosure.model_updated", :model => self)
          end
        end
      end
    end
  end
end