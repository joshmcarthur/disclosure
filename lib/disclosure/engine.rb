module Disclosure
  class Engine < ::Rails::Engine
    isolate_namespace Disclosure

    initializer 'disclosure.subscribe_to_model_events' do
      Disclosure::Notifications.subscribe!
    end

    initializer 'disclosure.instrument_model_events' do
      Disclosure::Notifications.instrument!
    end

    initializer 'disclosure.extend_model_classes' do
      Disclosure.bootstrap!
    end
  end
end
