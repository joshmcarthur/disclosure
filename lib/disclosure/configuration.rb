class Disclosure::Configuration 
  attr_accessor :owner_class, :notifier_classes, :reactor_classes, :mail_sender

  def initialize
    self.owner_class = "User"
    self.reactor_classes = [Disclosure::EmailReactor]
    self.notifier_classes = []
    self.mail_sender = "please-change-me@localhost"
  end

end