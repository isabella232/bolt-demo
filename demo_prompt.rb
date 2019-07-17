require 'tty-prompt'
require 'tty-command'

class DemoPrompt < TTY::Prompt
  def initialize
    @quiet_cmd = TTY::Command.new(uuid: false,
                                  pty: true,
                                  printer: :quiet)
    super
  end

  def quiet_command(command)
    @quiet_cmd.run!(command)
  end

  def run_command(valid_regex = nil)
    # TODO: Tab complete Bolt commands
    a = ask("$ ") do |c|
      if valid_regex
        c.validate valid_regex
      end
    end

    @quiet_cmd.run!(a)
  end

  def say(message)
    super("\n#{style_command(message)}\n", color: :white)
  end

  def style_command(message)
    message.gsub("{{", "\e[38;5;49m").gsub("}}", "\e[0m")
  end

  def clear_screen
    @quiet_cmd.run!('clear')
  end
end