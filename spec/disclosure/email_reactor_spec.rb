require 'spec_helper'

describe Disclosure::EmailReactor do
  subject do
    Disclosure::EmailReactor
  end

  let(:model) { Disclosure::Issue.new }
  let(:action) { "closed" }
  let(:user) { OpenStruct.new(:email => "tester@example.com") }
  let(:rule) { 
    Disclosure::Rule.new.tap do |rule|
      rule.stub(:owner).and_return(user)
      rule.notifier_class = "issue"
      rule.action = action
    end
  }

  describe ".react!" do
    it "should build a notification email" do
      subject.any_instance.should_receive(:notification).with(model, action, user).and_call_original
      subject.react!(model, action, user)
    end

    it "should deliver the email" do
      notification = subject.notification(model, action, user)
      notification.should_receive(:deliver).and_return(true)
      subject.any_instance.stub(:notification).and_return(notification)
      subject.react!(model, action, user)
    end
  end

  describe ".notification" do
    before do
      store_translations :en, :disclosure => { :email_reactor => { :'disclosure/issue' => { :closed => { :subject => 'Issue closed notification' } } } } do
        @notification = subject.notification(model, action, user)
      end
    end

    it "should return a message" do
      @notification.should be_a Mail::Message
    end

    it "should have a subject" do
        @notification.subject.should eq "Issue closed notification"
    end

    it "should be from the configuration from address" do
      @notification.from.should eq [Disclosure.configuration.mail_sender]
    end

    it "should be addressed to the rule owner" do
      @notification.to.should eq ["tester@example.com"]
    end
  end
end