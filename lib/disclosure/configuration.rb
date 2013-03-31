class Disclosure::Configuration 
  attr_accessor :owner_class, :notifier_classes, :reactor_classes

  def initialize
    self.owner_class = "User"
    self.reactor_classes = []
    self.notifier_classes = []
  end

end