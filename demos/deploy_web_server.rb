require 'executor' 
class DeployWebServer < Demo
  def self.title
    "Deploy a Web Server"
  end

  def run
    bolt_apply_demo
    @prompt.say("Thanks for completing our demo! Feel free to play with Bolt in our VM environment, or ask us any questions.")
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
