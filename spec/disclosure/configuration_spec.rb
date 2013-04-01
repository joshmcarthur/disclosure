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

  it "should have an accessor for email reactor defaults" do
    subject.should respond_to "email_reactor_defaults"
    subject.should respond_to "email_reactor_defaults="
  end

  it "should have a default for owner class" do
    subject.owner_class.should eq "User"
  end

  it "should have a default for notifier classes" do
    subject.notifier_classes.should eq []
  end

  it "should have a default for reactor classes" do
    subject.reactor_classes.should eq []
  end

  it "should have a default for email reactor defaults" do
    subject.email_reactor_defaults.should be_a Hash
  end

end