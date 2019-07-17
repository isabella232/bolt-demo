module Demo
  class DeployingWebServer
    def initialize(prompt)
      @prompt = prompt
    end

    def self.title
      "Deploying a Web Server"
    end

    def run
      run_command_demo
      yaml_plan_demo
      bolt_apply_demo
      @prompt.say("Thanks for completing our demo! Feel free to play with Bolt in our VM environment, or ask us any questions.")
    end

    def run_command_demo
      # Stop httpd on targets
      stop_httpd = "bolt command run 'systemctl stop httpd' -n target0"
      timeout_httpd = "bolt command run \"sed -i -E 's/^Timeout [0-9]+$/Timeout 100/g' /etc/httpd/conf/httpd.conf\" -n target0'"
      # run! Doesn't fail on errors
      TTY::Command.new(uuid: false, printer: :null).run!(stop_httpd)
      TTY::Command.new(uuid: false, printer: :null).run!(timeout_httpd)
  
      # Get status of Apache
      @prompt.clear_screen
      @prompt.say(<<~WELCOME)
      Welcome to Bolt! It's easy to get started with.
      You can run commands on remote systems with {{bolt command run <command> -n <hostnames>}}

      Try it out: {{bolt command run 'systemctl status httpd' -n target0}}
      WELCOME
  
      @prompt.run_command(/bolt command run .* -n .*/)
  
      @prompt.say("Woops - looks like Apache has stopped on those nodes.")
      @prompt.keypress("Press enter to continue", keys: [:return])
  
      # TODO: Single quotes in regex
      # Start Apache
      @prompt.clear_screen
      @prompt.say("Let's restart it: {{bolt command run 'systemctl start httpd' -n target0}}")
      @prompt.run_command(/bolt command run .* -n .*/)
  
      @prompt.say("And make sure it's still working")
      check = "bolt command run 'systemctl status httpd' -n target0"
      @prompt.quiet_command(check)
  
      @prompt.say("Great, looks like Apache is back up and running!")
      @prompt.keypress("Press enter to continue", keys: [:return])
    end
  
    def yaml_plan_demo
      @prompt.clear_screen
      @prompt.say(<<~INST)
      Bolt plans compose multiple Bolt steps together, and share data between those steps
      Bolt supports plans written in YAML. For example, this plan updates the Apache config file then uses the builtin service task to restart httpd
      INST
  
      cat = 'cat Boltdir/site-modules/demo/plans/update_timeout.yaml'
      @prompt.quiet_command(cat)
  
      # Extra newline after `cat`
      @prompt.say("\nRun the plan: {{bolt plan run demo::update_timeout timeout=200 -n target0}}")
      # TODO: Colons in regex
      @prompt.run_command(/bolt plan .* timeout=\d+ -n.*/) 
  
      @prompt.say("Awesome! Remote apache configuration made easy")
      @prompt.keypress("Press enter to continue", keys: [:return])
    end
  
    def bolt_apply_demo
      @prompt.clear_screen
      @prompt.say(<<~INST)
      Lastly, Bolt plans written in Puppet can leverage existing Puppet modules.
      This is a powerful way to set up complex infrastructure in a few lines, without needing to understand all of Puppet
      For example, this Puppet plan uses the Apache Puppet module to quickly deploy an apache webserver - without managing a Puppet master or agent!
      INST
  
      cat = 'cat Boltdir/site-modules/demo/plans/deploy_apache.pp'
      @prompt.quiet_command(cat)
  
      @prompt.say("Try it out: {{bolt plan run demo::deploy_apache -n target0}}")
      @prompt.run_command(/bolt plan run .* -n .*/)
      @prompt.keypress("Check it out at 10.0.0.100\nPress 'enter' to continue", keys: [:return])
    end
  end
end
