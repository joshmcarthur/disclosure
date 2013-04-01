require "disclosure/engine"
require 'disclosure/exceptions'
require "disclosure/configuration"

module Disclosure
  class << self
    attr_accessor :configuration
  end

  def self.bootstrap!
    Disclosure.configuration.notifier_classes.each do |klass|
      if !klass.methods.include?(:notifiable_actions)
        klass.class_eval do
          class << self
            def notifiable_actions
              raise Disclosure::NotifiableActionsNotDefined.new("Notifiable actions must be defined in #{self.name}.")
            end
          end
        end
      end

      # We don't use an else here, because we may have *just* added
      # the method - it's not a if this, else that - we may need to do both
      if klass.methods.include?(:notifiable_actions) 
        # If notifiable actions has just been defined, it will raise an exception
        (klass.notifiable_actions rescue []).each do |action|
          unless klass.instance_methods.include?(:"#{action}?")
            klass.send :define_method, :"#{action}?" do
              raise Disclosure::ActionMethodNotDefined.new("#{action}? must be defined in #{klass}.")
            end
          end
        end
      end
    end
  end

  def self.react_to!(model)
    unless Disclosure.configuration.notifier_classes.include?(model.class) 
      return nil
    end

    Disclosure::Rule.where(
      :notifier_class => model.class.name,
      :owner_id => model.send("#{Disclosure.configuration.owner_class.underscore}_id")
    ).each do |rule|
      next if !model.send("#{rule.action}?")
      rule.react!(model)
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end
