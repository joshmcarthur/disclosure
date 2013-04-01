module Disclosure
  class EmailReactor < ActionMailer::Base
    default Disclosure.configuration.email_reactor_defaults

    def react!(model, action, rule)
      self.notification(model, action, rule).deliver
    end

    def notification(model, action, rule)
      mail(
        :to => rule.owner.email,
        :subject => t("disclosure.email_reactor.#{rule.notifier_class}.#{action}.subject"),
        :template_path => "disclosure/email/#{rule.notifier_class}",
        :template_name => "action"
      )
    end
  end
end
