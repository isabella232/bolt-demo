require 'executor'
class YamlPlan < Demo
  def self.title
    "Yaml Plans"
  end

  def run
    @prompt.clear_screen
    @prompt.say(<<~INST)
      Bolt plans compose multiple Bolt steps together, and share data between those steps
      Bolt supports plans written in YAML. For example, this plan updates the Apache config file then uses the builtin service task to restart httpd
    INST

    cat = 'cat Boltdir/site-modules/demo/plans/update_timeout.yaml'
    @prompt.quiet_command(cat)

    @prompt.say("\nRun the plan: {{bolt plan run demo::update_timeout timeout=200 -n target0}}")
    @prompt.run_command(/bolt plan .* timeout=\d+ -n.*/)

    @prompt.say("Awesome! Remote apache configuration made easy")
  end
end
