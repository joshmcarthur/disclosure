require 'spec_helper'

describe Disclosure do
  it "should be a module" do
    subject.should be_a Module
  end

  it "should have an engine" do
    Disclosure::Engine.superclass.should eq ::Rails::Engine
  end

  it "should be configurable directly" do
    Disclosure.configuration.owner_class = "Administrator"
    Disclosure.configuration.owner_class.should eq "Administrator"
  end

  it "should be configurable using a block" do
    Disclosure.configure do |config|
      config.owner_class = "Administrator"
    end

    Disclosure.configuration.owner_class.should eq "Administrator"
  end
end