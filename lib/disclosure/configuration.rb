class Disclosure::Configuration 
  attr_accessor :owner_class, :notifier_classes, :reactor_classes, :email_reactor_defaults

  def initialize
    self.owner_class = "User"
    self.reactor_classes = []
    self.notifier_classes = []
    self.email_reactor_defaults = {:from => "please-change-me@localhost"}
  end

end