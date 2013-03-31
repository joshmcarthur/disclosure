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

  describe "bootstrapping" do
    subject do
      Disclosure::Issue
    end


    describe "class methods" do

      before do
        class Disclosure::Issue
          (class << self; self; end).send :remove_method, :notifiable_actions
        end

        Disclosure.bootstrap!
      end
      it "should add a notifiable method to the notifier class" do
        subject.should respond_to :notifiable_actions
      end

      it "should raise an exception until this method is filled out by the user" do
        expect {
          Disclosure::Issue.notifiable_actions
        }.to raise_exception Disclosure::NotifiableActionsNotDefined
      end
    end

    describe "instance methods" do
      before do
        class Disclosure::Issue
          def self.notifiable_actions
            %w( closed ) 
          end

          undef :closed?
        end

        Disclosure.bootstrap!
      end

      it "should add a method for each of the notifier class's actions" do
        subject.new.should respond_to :closed?
      end

      it "should raise an exception until this method is filled out by the user" do
        expect { 
          subject.new.closed?
        }.to raise_exception Disclosure::ActionMethodNotDefined
      end
    end
  end

  describe "react_to!" do

    let(:model) { Disclosure::Issue.new }
    let(:rule) { Disclosure::Rule.new.tap { |r| r.action = 'closed' } }

    context "model is not reactable" do
      let(:model) { String.new }

      it "should not react" do
        Disclosure::Rule.any_instance.should_not_receive(:react!)
        subject.react_to!(model)
      end

      it "should return nil" do
        subject.react_to!(model).should be_nil
      end
    end

    it "should find matching rules" do
      Disclosure::Rule.any_instance.stub(:react!)
      Disclosure::Rule.should_receive(:where).with(
        :notifier_class => "Disclosure::Issue",
        :owner_id => 1
      ).and_return([rule])
      subject.react_to!(model)
    end

    it "should reject rules whose action does not match" do
      model.stub(:closed?).and_return(false)
      rule.should_not_receive :react!
      Disclosure::Rule.stub(:where).and_return([rule])

      subject.react_to!(model)
    end

    it "should react to matching rules" do
      Disclosure::Rule.stub(:where).and_return([rule])
      rule.should_receive(:react!).once()

      subject.react_to!(model)
    end
  end

  describe "subscription" do
    let(:model) { Disclosure::Issue.new }

    it "should be subscribed to the model event" do
      subject.should_receive(:react_to!).with(model)
      model.save
    end
  end
end