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
          around_save :notify_disclosure_with_save

          private

          def notify_disclosure_with_save
            # Keep track of the original model to pick up changes properly
            @model_before_save = self

            # Call save, etc.
            yield

            # Send the notification with the original model
            ActiveSupport::Notifications.instrument("disclosure.model_saved", :model => @model_before_save)
          end
        end
      end
    end
  end
end