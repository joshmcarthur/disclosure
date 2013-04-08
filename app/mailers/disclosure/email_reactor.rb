module Disclosure
  class EmailReactor < ActionMailer::Base
    default from: Proc.new { Disclosure.configuration.mail_sender }

    def react!(model, action, user)
      self.notification(model, action, user).deliver
    end

    def notification(model, action, user)
      @model = model
      @action = action
      @user = user
      @subject = t("disclosure.email_reactor.#{model.class.name.underscore}.#{action}.subject")
      mail(
        :to => @user.email,
        :subject => @subject,
        :template_path => "disclosure/email/#{model.class.name.underscore}",
        :template_name => @action
      )
    end
  end
end
