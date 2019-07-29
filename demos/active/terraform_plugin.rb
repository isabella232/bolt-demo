require 'executor'
class TerraformPlugin < Demo
  def self.title
    "Terraform Inventory Plugin"
  end

  def run
    @prompt.say(<<~INST)
      Bolt uses an inventory file to store target connection information.
      Inventories can use plugins which dynamically load data from a variety of sources such as Terraform or AWS. Bolt also has plugins for encrypting or prompting for data.

      This example uses the Terraform and PKCS7 plugins.

      This is our inventoryfile.yaml:
    INST

    @prompt.quiet_command('cat Boltdir/inventory.yaml')

    # TODO: What's a better command?
    @prompt.say("Try it out: {{bolt command run 'hostname' -n tf}}")
    @prompt.run_command(/bolt command run .* -n .*/)
  end
end
