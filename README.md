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

### Reporting bugs, adding features

### License

MIT Licence. See the _MIT-LICENSE_ file for details.

