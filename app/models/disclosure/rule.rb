module Disclosure
  class Rule < ActiveRecord::Base
    belongs_to :owner, :class_name => Disclosure.configuration.owner_class

    validates :notifier_class, :inclusion => {
      :in => proc { Disclosure.configuration.notifier_classes.map(&:name) }
    }

    validates :reactor_class, :inclusion => {
      :in => proc { Disclosure.configuration.reactor_classes.map(&:name) }
    }

    validates :action, :uniqueness => {
      :scope => [:owner_id, :notifier_class]
    }

    validate :action_in_notifier_actions

    # Public: Find the notifier class instance from the
    # class name (string) that is saved in the model table.
    #
    # Returns the notifier class or nil
    def notifier
      Disclosure.configuration.notifier_classes.select do |nc|
        nc.name == self.notifier_class
      end.first
    end

    # Public: Find the reactor class instance from the
    # class name (string) that is saved in the model table.
    #
    # Returns the reactor class or nil   
    def reactor
      Disclosure.configuration.reactor_classes.select do |rc|
        rc.name == self.reactor_class
      end.first
    end

    # Public: Tell the reactor for this rule that it should now react to a change.
    #
    # Passes along the instance of the model that changed, the action that occurred, 
    # and the owner of the rule
    #
    # model - The model instance that changed
    #
    # Returns truthy value if the reactor returned successfully, and false if not.
    # Depending on the reactor, may raise exceptions - for example, Net::SMTP errors
    # if sending email.
    def react!(model)
      reactor.react!(model, action, owner)
    end

    private

    # Private: Ensure that the configured action is within the 
    # actions recorded against the notifier.
    #
    # For example, an Issue may notify actions such as:
    # * created
    # * closed
    #
    # While a Project may only notify creating and updating actions
    #
    # Returns true if the action is valid, or false if not
    def action_in_notifier_actions
      unless notifier && notifier.notifiable_actions.include?(self.action)
        errors.add(:action, :not_in_notifiable_actions)
        return false
      end

      return true
    end
  end
end
