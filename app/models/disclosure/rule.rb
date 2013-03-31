module Disclosure
  class Rule < ActiveRecord::Base
    belongs_to :owner, :class_name => Disclosure.configuration.owner_class
  end
end
