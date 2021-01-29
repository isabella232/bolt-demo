class RunCommand < Demo
  def self.title
    "Run a command"
  end

  def run
    stop_httpd = "bolt command run 'systemctl stop httpd' -n target0"
    @prompt.quiet_command(stop_httpd)
    @prompt.clear_screen
    @prompt.say(<<~WELCOME)
      Welcome to Bolt! It's easy to get started with.
      You can run commands on remote systems with {{bolt command run <command> -n <hostnames>}}

      Try it out: {{bolt command run 'systemctl status httpd' -n target0}}
    WELCOME

    @prompt.run_command(/bolt command run .* -n .*/)

    @prompt.say("Woops - looks like Apache has stopped on those nodes.")
    @prompt.keypress("Press enter to continue", keys: [:return])

    @prompt.clear_screen
    @prompt.say("Let's restart it: {{bolt command run 'systemctl start httpd' -n target0}}")
    @prompt.run_command(/bolt command run .* -n .*/)

    @prompt.say("And make sure it's still working")
    check = "bolt command run 'systemctl status httpd' -n target0"
    @prompt.quiet_command(check)

    @prompt.say("Great, looks like Apache is back up and running!")
  end
end
