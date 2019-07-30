class GenericCommandRun < Demo
  def self.title
    "Bolt Command Run"
  end

  def run
    @prompt.say(<<~SAY)
      Basic Bolt Commands

      Bolt has several built-in commands that let you run commands, scripts, tasks, and plans on a set of remote hosts.
      This demo will go over the basic commands you'll need to get started with Bolt.
    SAY

    @prompt.keypress("Press enter to continue", keys: [:return])
    @prompt.clear_screen

    @prompt.say(<<~SAY)
      You can use Bolt to run arbitrary commands on a set of remote hosts. Let’s see that in practice before we move on to more advanced features. 
      To run a command, use the {{bolt command run}} command. Let's see how long the host target0 has been running.

      Run this: {{bolt command run uptime --targets target0}}
    SAY

    @prompt.run_command(/bolt command run uptime --targets target0/)

    @prompt.keypress("Press enter to continue", keys: [:return])
    @prompt.clear_screen
    @prompt.say(<<~CLOSE)
      Thanks for completing the demo!
      Now that you know how to use some of Bolt's commands, you can move on to other modules.
    CLOSE
  end
end
