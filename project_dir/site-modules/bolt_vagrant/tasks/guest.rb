#!/usr/bin/env ruby
require 'json'

begin
  targets = File.readlines("/etc/hosts").map! { |l| l.strip }
rescue StandardError => e
  result = {_error: {msg: e.message}}
  puts result.to_json
  exit 1
end

targets.reject! { |e| e.to_s.empty? || e.include?("localhost") }
targets.map! do |t|
  uri, name = t.split
  { name: name,
    uri: uri }
end

inv = { targets: targets }
puts inv.to_json
exit 0
