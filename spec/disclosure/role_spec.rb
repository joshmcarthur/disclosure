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
end