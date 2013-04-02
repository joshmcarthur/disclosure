module Disclosure
  class EmailReactor < ActionMailer::Base
    default Disclosure.configuration.email_reactor_defaults

    def react!(model, action, user)
      self.notification(model, action, user).deliver
    end

    def notification(model, action, user)
      mail(
        :to => user.email,
        :subject => t("disclosure.email_reactor.#{model.class.name.underscore}.#{action}.subject"),
        :template_path => "disclosure/email/#{model.class.name.underscore}",
        :template_name => "action"
      )
    end
  end
end
