class InventoryShow < Demo
  def self.title
    "Inventory show command"
  end

  def run
    @prompt.say(<<~INTRO)
    Bolt has a subcommand 'inventory show', which accepts a target specification and returns the targets that exist in the inventory and match the spec.
    For example, {{bolt inventory show -t localhost}} will return just 'localhost' if it's in the inventory, and nothing if it isn't.
    You can also use {{-n all}}, {{--rerun failure}}, or {{-q query}} to get lists of nodes.
    Try it out: {{bolt inventory show -t all}}
    INTRO

    @prompt.run_command(/bolt inventory show -t all/)

    @prompt.say("You can also try specifying just a group name, like {{bolt inventory show -t vms}}")
    @prompt.run_command(/bolt inventory show -t vms/)
  end
end
