# Bolt Demo

A self service demo of Bolt capabilities. This includes a vagrant environment in which to run the demo, a demo engine written in ruby, and a library of Bolt demos.

## Setup

You can either install Bolt from the published package, or provide the path to a local package by setting the `BOLT_PACKAGE` environment variable to the absolute path to the package. The Bolt controller is a CentOS 7 machine.

```
export BOLT_PACKAGE=/home/user/bolt-vanagon/output/el/puppet-bolt.rpm
```

To bring the environment up run:

`vagrant up`

## Run the Demos
```
vagrant ssh bolt
./executor.rb
```

## Adding a Demo

To add a demo, create a new ruby script that contains a class that inherits from the `Demo` class. The only function you need to define is `run`, and you can  optionally include a `title` method to print a title.

```
class MyDemo < Demo
  def self.title
    "Title of My Demo"
  end

  def run
  end
end
```

There are a few methods you'll want to use for your demo:

TODO

### Kudos

Thanks to [tty-prompt](https://github.com/piotrmurach/tty-prompt) for providing a great demo engine!
