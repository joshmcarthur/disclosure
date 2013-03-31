require "disclosure/engine"
require "disclosure/configuration"

module Disclosure
  class << self
    attr_accessor :configuration
  end

  def self.bootstrap!
    Disclosure.configuration.notifier_classes.each do |klass|
      unless klass.methods.include?(:notifiable_actions)
        klass.define_method(:notifiable_actions) do
          raise ::NotImplementedError, "Notifiable actions must be defined in #{klass.name}."
        end
      end

      klass.notifiable_actions.each do |action|
        unless klass.instance_methods.include?(:"#{action}?")
          klass.define_method(:"#{action}?") do
            raise ::NotImplementedError, "#{action}? must be defined in #{klass}."
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
