class TaskPlugin < Demo
  def self.title
    "Task Inventory Plugin"
  end

  def run
    @prompt.say(<<~INTRO)
    Bolt supports inventory plugins you can write yourself, as tasks.
    The Task plugin will run a task on localhost to lookup configuration information or target lists for the inventory.
    This demo actually uses a Task plugin to load the Vagrant VMs into the inventory.
    This is the task:
    INTRO
    @prompt.quiet_command("cat Boltdir/site-modules/bolt_vagrant/tasks/guest.rb")
    @prompt.keypress("Press enter to continue")
    @promt.clear_screen

    @prompt.say("And this is the inventory")
    @prompt.quiet_command("cat Boltdir/inventory.yaml")
    @prompt.keypress("Press enter to continue")
    @prompt.clear_screen

    @prompt.say("Now I can run Bolt on my vagrant VMs: {{bolt command run 'hostname' -n vms}}")
    @prompt.run_command(/bolt command run .* -n .*/)
  end
end
