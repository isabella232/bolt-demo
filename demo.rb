#!/usr/bin/env ruby

require 'tty-prompt'
require 'tty-command'

class BoltDemo
  def initialize
    @prompt = TTY::Prompt.new
    @quiet_cmd = TTY::Command.new(uuid: false,
                                  pty: true,
                                  printer: :quiet)
  end

  def run
    run_command_demo
    yaml_plan_demo
    bolt_apply_demo
    bolt_say("Thanks for completing our demo! Feel free to play with Bolt in our VM environment, or ask us any questions.")
  end

  def run_command(valid_regex = nil)
    # TODO: Tab complete Bolt commands
    a = @prompt.ask("$ ") do |c|
      if valid_regex
        c.validate valid_regex
      end
    end

    @quiet_cmd.run!(a)
  end

  def bolt_say(message)
    @prompt.say("\n#{style_command(message)}\n", color: :white)
  end

  def style_command(message)
    message.gsub("{{", "\e[38;5;49m").gsub("}}", "\e[0m")
  end

  def clear_screen
    @quiet_cmd.run!('clear')
  end

  def run_command_demo
    # Stop httpd on targets
    stop_httpd = "bolt command run 'systemctl stop httpd' -n target0 &&" \
    "bolt command run \"sed -i -E 's/^Timeout [0-9]+$/Timeout 100/g' /etc/httpd/conf/httpd.conf\" -n target0'"
    # run! Doesn't fail on errors
    TTY::Command.new(uuid: false, printer: :null).run!(stop_httpd)
    clear_screen

    # TODO: It'd be nice if this 'typed'
    bolt_say(<<~WELCOME)
    Welcome to Bolt! It's easy to get started with.
    You can run commands on remote systems with {{bolt command run <command> -n <hostnames>}}

    Try it out: {{bolt command run 'systemctl status httpd' -n target0}}
    WELCOME

    run_command(/bolt command run .* -n .*/)

    bolt_say(<<~INST)
    Woops - looks like Apache has stopped on those nodes
    Let's restart it: {{bolt command run 'systemctl start httpd' -n target0'}}
    INST

    # TODO: Single quotes in regex
    run_command(/bolt command run .* -n .*/)

    bolt_say("And make sure it's still working")
    check = "bolt command run 'systemctl status httpd' -n target0"
    @quiet_cmd.run!(check)

    bolt_say("Great, looks like Apache is back up and running!")
    @prompt.keypress("Press enter to continue", keys: [:return])
    clear_screen
  end

  def yaml_plan_demo
    bolt_say(<<~INST)
    Bolt plans compose multiple Bolt steps together, and share data between those steps
    Bolt supports plans written in YAML. For example, this plan updates the Apache config file then uses the builtin service task to restart httpd
    INST

    cat = 'cat Boltdir/site-modules/demo/plans/update_timeout.yaml'
    @quiet_cmd.run!(cat)

    # Extra newline after `cat`
    bolt_say("\nRun the plan: {{bolt plan run demo::update_timeout timeout=200 -n target0}}")
    # TODO: Colons in regex
    run_command(/bolt plan .* timeout=\d+ -n.*/) 

    bolt_say("Awesome! Remote apache configuration made easy")
    @prompt.keypress("Press enter to continue", keys: [:return])
    clear_screen
  end

  def bolt_apply_demo
    bolt_say(<<~INST)
    Lastly, Bolt plans written in Puppet can leverage existing Puppet modules.
      This is a powerful way to set up complex infrastructure in a few lines, without needing to understand all of Puppet
    For example, this Puppet plan uses the Apache Puppet module to quickly deploy an apache webserver - without managing a Puppet master or agent!
    INST

    cat = 'cat Boltdir/site-modules/demo/plans/deploy_apache.pp'
    @quiet_cmd.run!(cat)

    bolt_say("Try it out: {{bolt plan run demo::deploy_apache -n target0}}")
    run_command(/bolt plan run .* -n .*/)
    @prompt.keypress("Check it out at 10.0.0.100\nPress 'enter' to continue")
  end
end

BoltDemo.new.run if __FILE__ == $0
