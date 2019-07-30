class AWSPlugin < Demo
  def self.title
    "AWS Plugin"
  end

  def run
    @prompt.say(<<~INTRO)
    Bolt has a new inventory plugin: aws::ec2!
    The AWS EC2 plugin looks up running EC2 instances, and includes keys for filtering them.
    Let's see it in action:
    INTRO
    @prompt.quiet_command("cat Boltdir/aws-inventory.yaml")
    @prompt.keypress
    @prompt.clear_screen
    @prompt.say("{{bolt command run hostname -n aws -i Boltdir/aws-inventory.yaml}}")
    @prompt.run_command(/bolt command run .* -n aws -i Boltdir\/aws-inventory.yaml/)
  end
end
