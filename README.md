disclosure
---

A Rails engine to allow you to easily set up rules and events for user notifications.

Disclosure is used in production for [Inquest](https://github.com/joshmcarthur/inquest) and is fully covered by RSpec tests.

### What is disclosure?

Disclosure makes the process of adding user-configurable notifications (where a notification is just **something** that goes to a user), quick and easy to add. It adds most of the bootstrap code needed, so that the developer can focus on configuration and functionality specific to your application.

The core of disclosure is a `Disclosure::Rule`. A rule is comprised of a **notifier**, a **reactor**, and an **action**, and is owned by an **owner**.

* **Notifier:** a notifier is a model that inherits from `ActiveRecord::Base` that triggers a notification when it is changed in certain ways (whether a notification is triggered or not also depends on the **action**.)
* **Reactor:** a reactor is a class that handles something (anything!) happening. A reactor can expect to be passed a model that changed, the action that was recognized as happening, and the owner of that rule, and can itself be expected to communicate that somehow to the user.
* **Action:** an action is something that might happen to a notifier. Actions may be different for each type of model - for examplean an `Issue` may notify actions such as: 'created', 'closed', While a `Project` may only notify creating and updating actions.

When an instance of a model that `disclosure` recognizes as being a notifier is saved, the library first checks whether any user-created rules match the model type being saved. If there are any, they are further filtered to only include the rules that match the 'action' occurring - for example, if the 'closed' attribute of the `Issue` is changing, then the action should be detected as 'closed' - if a different attribute is changing, a normal 'updated' action will do. Each of these matching rules is then told to "react", by passing all information needed to the "reactor" to pass on to the user.


### How to install disclosure?

Disclosure is very easy to install, however once installed, it requires a little configuration. This is because the library needs to know a few specific things about your application to work.

First, install the application using Rubygems:

``` bash
gem install disclosure
```

Next, add an initializer to your Rails application and feel free to override the following config:

``` ruby
Disclosure.configure do |config|
  config.owner_class = "User"
  config.reactor_classes = []
  config.notifier_classes = []
end
```

For example, if the owner of your notification rules is called `Administrator` not `User`, simply change:

``` ruby
config.owner_class = "User"
``` 

to:

``` ruby
config.owner_class = "Administrator"
```

If you have two models that need to have notifications called `Project` and `Issue`, then you would configure the collection of notifier classes, like so:

``` ruby
config.notifier_classes = [Project, Issue]
```

And, if you have added a special reactor to your application (say, one that sends SMS messages to your users), you would add this to the list of the reactor classes like so:

``` ruby
config.reactor_classes << YourApplication::SMSReactor
```

(Using `<<` here so that the main reactor that comes with Disclosure, `Disclosure::EmailReactor`, is not removed from the list of available reactors).

Disclosure also expects that some methods are defined in your notifier classes, as there are some things that cannot be figured out - they are specific to your application.

The first of these methods should be a class method defined on your notifier class, called `notifiable_actions`. This method should return an array of symbols or strings that represent the names of actions available for this notifier class. This list is used to validate that a rule's action is OK for the notifier class attached to the rule, and to figure out whether any of the actions for a notifier class have been triggered when Disclosure receives a notification that the class has changed.

For example, to define the notifiable actions for our `Project` class, we would add the following method:

``` ruby
class Project < ActiveRecord::Base
  # …
  def self.notifiable_actions
    [:closed, :created]
  end
end
```

The other methods that must be defined depend on the actions available to each notifier class. Each action on the class must have a method named the same as the action, with the word 'happened' and a question mark (`?`) on the end - for example, the 'closed' action must have a `closed_happened?` method. The method should return true if the model has just changed in a way that this action applies, or false if not. **Please remember that the action method should check whether the action has _just_ applied, not whether it applies now - i.e. you should be checking whether attributes have changed _and_ match 'x', not just that they match 'x'.**.

For example, here is how we might define the `closed_happened?` method for our project:

``` ruby
class Project < ActiveRecord::Base
  # …
  def closed_happened?
    closed_changed? && closed
  end
end
```

If you forget to define any of these methods, Disclosure will raise an error, explaining the method name that you need to define on which class - so don't panic!


### Reporting bugs, adding features

Bugs should be reported on [Github](https://github.com/joshmcarthur/disclosure/issues), where they can be commented on, prioritized, and visible to all. 

If you have a bugfix or feature you would like to contribute, please follow the process below:

1. Set up the project: Fork the repository on Github and run `git clone git@github.com:[username]/disclosure.git` and `bundle install` to download and install dependencies.
2. Run `rake` to make sure that all tests are currently passing (they should be)
3. Create a new branch in git to contain your changes - if you are contributing a bugfix, please prefix the branch with `bugfix/` - otherwise, prefix with `feature/`, and add a short branch name that describes the fix - e.g. `bugfix/issue-5-fix-spelling`.
4. Make your changes, running `rake` occasionally to check you haven't broken anything. If you are adding new features, be sure to add tests for them (see the `spec` directory for existing tests you can base off)
5. Push your branch to your repository, and create a pull request. This will allow me to review your changes, and request that something be fixed if it's not right on your branch. When the specs are passing and it looks good, I'll merge.

### License

MIT Licence. See the _MIT-LICENSE_ file for details.

