require 'spec_helper'

describe Disclosure::Rule do
  it "should inherit from active record" do
    subject.class.superclass.should eq ActiveRecord::Base
  end

  it "should have a belongs_to owner relationship" do
    subject.attributes.should include "owner_id"
    subject.should respond_to :owner=
  end

  it "should store the notifing class" do
    subject.attributes.should include "notifier_class"
  end

  it "should store the reactor class" do
    subject.attributes.should include "reactor_class"
  end

  it "should store the action to respond to" do
    subject.attributes.should include "action"
  end


  it "should return the notifier class using the notifier getter" do
    subject.notifier_class = "Disclosure::Issue"
    subject.notifier.should eq Disclosure::Issue
  end

  it "should return the reactor class using the reactor getter" do
    subject.reactor_class = "Disclosure::TestReactor"
    subject.reactor.should eq Disclosure::TestReactor
  end

  describe "notifier class validation" do
    it "should be invalid if the class is not in the allowed list" do
      subject.notifier_class = "Unknown"
      subject.valid?
      subject.errors[:notifier_class].should_not be_blank
    end

    it "should be valid if the class is in the allowed list" do
      subject.notifier_class = "Disclosure::Issue"
      subject.valid?
      subject.errors[:notifier_class].should be_blank
    end
  end

  describe "reactor class validation" do
    it "should be invalid if the class is not in the allowed list" do
      subject.reactor_class = "Unknown"
      subject.valid?
      subject.errors[:reactor_class].should_not be_blank
    end

    it "should be valid if the class is in the allowed list" do
      subject.reactor_class = "Disclosure::TestReactor"
      subject.valid?
      subject.errors[:reactor_class].should be_blank
    end
  end

  describe "actions validation" do
    it "should require an action be present" do
      subject.action = nil
      subject.valid?
      subject.errors[:action].should_not be_blank
    end

    it "should be valid if the action is in the notifier class actions list" do
      subject.notifier_class = "Disclosure::Issue"
      subject.action = "closed"
      subject.valid?
      subject.errors[:action].should be_blank
    end

    it "should not be valid if the action is not in the notifier class actions list" do
      subject.action = "unknown"
      subject.valid?
      subject.errors[:action].should_not be_blank
    end
  end
end