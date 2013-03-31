$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "disclosure/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "disclosure"
  s.version     = Disclosure::VERSION
  s.authors     = ["Josh McArthur"]
  s.email       = ["joshua.mcarthur+disclosure@gmail.com"]
  s.homepage    = "https://github.com/joshmcarthur/disclosure"
  s.summary     = "A Rails engine to allow you to easily set up rules and events for notificaitons."
  s.description = "A Rails engine to allow you to easily set up rules and events for " +
                  "when each user should receive notifications - great for adding " +
                  "configurable notifications."


  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
