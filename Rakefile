# Loading Ruby libs
require 'rubygems'
require 'flowdock'
require 'eventmachine'
require 'em-http'
require 'net/https'
require 'uri'
require 'json'
require 'steam-condenser'
require 'rdoc'

require_relative 'config'
require_relative 'starkbot/starkbot'
require_relative 'utils/string'
require_relative 'utils/array'

namespace :starkbot do

  desc "Create and connect a bot to Flowdock Stream API"
  task :run do
    @bot = StarkBot.new($username, $token, $organization, $flows)
    @bot.load($plugins)
    @bot.connect
  end

  desc "List current loaded plugins"
  task :plugins do
    puts "Current plugins are: #{$plugins.to_sentence}"
  end

end
