module Disclosure
  class Engine < ::Rails::Engine
    isolate_namespace Disclosure

    initializer 'disclosure.subscribe_to_model_events' do
      ActiveSupport::Notifications.subscribe "disclosure.model_saved" do |name, start, finish, id, payload|
        Disclosure.react_to!(payload[:model])
      end
    end

    initializer 'disclosure.extend_model_classes' do
      Disclosure.bootstrap!
    end
  end
end
