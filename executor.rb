#!/usr/bin/env ruby
require './demo_prompt.rb'
$LOAD_PATH.unshift __dir__

class Demo
  def initialize(prompt)
    @prompt = prompt
  end

  def self.inherited(klass)
    # Class hasn't loaded, so there's no title method
    BoltDemo.load_demo(klass)
  end 

  def self.title
    self.to_s
  end
end

class BoltDemo
  @@demos = []
  attr_reader :prompt

  def initialize
    @prompt = DemoPrompt.new
    Dir[File.join(__dir__, "demos/active/*.rb")].each { |file| require file }
  end

  def self.load_demo(klass)
    raise("Demo #{klass} already loaded") if @@demos.include?(klass)
    @@demos << klass
  end

  def method_missing(name, *args)
    "Could not find method '#{name}'. Please define a function called #{name} in your Demo class"
  end

  def run
    loop do
      @prompt.clear_screen
      @prompt.say(<<~WELCOME)
      Welcome to Bolt! It's easy to get started with. Select a demo from the options below.
      WELCOME

      if @@demos.empty?
        raise("There are no demos to be loaded! Please move demos you want to run to the ./demos/active directory")
      end

      with_titles = Hash[@@demos.collect { |d| [d.title, d] }]
      with_titles["Exit"] = nil
      klass = @prompt.enum_select("", with_titles)
      if klass == "Exit"
        # TODO: This seems like an opportunity for something clever
        @prompt.say("Thanks for stopping by!")
        break
      end
      @prompt.clear_screen

      begin
        klass.new(@prompt).run
      rescue Exception => e
        raise("Could not create instance of demo #{klass}: #{e}")
      end
      @prompt.keypress("Press enter to continue")
    end
  end
end

BoltDemo.new.run if __FILE__ == $0
