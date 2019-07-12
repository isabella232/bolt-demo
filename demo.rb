#!/usr/bin/env ruby
require './demo_prompt.rb'

class BoltDemo
  def initialize
    @prompt = DemoPrompt.new

    # Load demos
    Dir[File.join(__dir__, "demos/active/*.rb")].each { |file| require file }
    @demos = Demo.constants.map.with_index { |demo, i| [ i + 1, Demo.const_get(demo) ] }.to_h || {}
  end

  def list_demos
    @demos.sort.map { |i, demo| "[#{i}]\t{{#{demo.title}}} " }.join("\n")
  end

  def run
    loop do
      @prompt.clear_screen
      @prompt.say(<<~WELCOME)
      Welcome to Bolt! It's easy to get started with. Select a demo from the options below.

      #{ list_demos }
      WELCOME

      choice = @prompt.ask("> ")
      @prompt.clear_screen

      if @demos[choice.to_i]
        @demos[choice.to_i].new(@prompt).run
        @prompt.keypress("Press enter to continue")
      elsif choice =~ /^[Qq](uit)?$/
        break
      end
    end
  end
end

BoltDemo.new.run if __FILE__ == $0
