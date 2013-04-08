require 'spec_helper'

describe Disclosure::Configuration do
  it "should have an accessor for the owner class to use" do
    subject.should respond_to "owner_class"
    subject.should respond_to "owner_class="
  end

  it "should have an accessor for notifier classes" do
    subject.should respond_to "notifier_classes"
    subject.should respond_to "notifier_classes="
  end

  it "should have an accessor for reactor classes" do
    subject.should respond_to "reactor_classes"
    subject.should respond_to "reactor_classes="
  end

  it "should have an accessor for mail sender" do
    subject.should respond_to "mail_sender"
    subject.should respond_to "mail_sender="
  end

  it "should have a default for owner class" do
    subject.owner_class.should eq "User"
  end

  it "should have a default for notifier classes" do
    subject.notifier_classes.should eq []
  end

  it "should have a default for reactor classes" do
    subject.reactor_classes.should eq [Disclosure::EmailReactor]
  end

  it "should have a default for mail sender" do
    subject.mail_sender.should match /.\@./
  end

end