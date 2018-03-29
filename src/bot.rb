# Gems
require 'discordrb'
require 'ostruct'
require 'yaml'
require 'rmagick'
require 'open-uri'
require 'opencv'
require 'faker'
require 'mojang'
require 'mediawiki-butt'
require 'nokogiri'
require 'yt'
require 'streamio-ffmpeg'

# The main bot module.
module Bot
  # Load non-Discordrb modules
  Dir['src/modules/*.rb'].each { |mod| load mod }

  # Bot configuration
  CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'

  # Create the bot.
  # The bot is created as a constant, so that you
  # can access the cache anywhere.
  # newlines are for nerds, I throw everything on one line, fuck off rubocop
  BOT = Discordrb::Commands::CommandBot.new(client_id: CONFIG.client_id, token: CONFIG.token, prefix: CONFIG.prefix, help_available: false, no_permission_message: '')

  Yt.configure do |config|
    config.api_key = CONFIG.youtube_token
  end

  # This class method wraps the module lazy-loading process of discordrb command
  # and event modules. Any module name passed to this method will have its child
  # constants iterated over and passed to `Discordrb::Commands::CommandBot#include!`
  # Any module name passed to this method *must*:
  #   - extend Discordrb::EventContainer
  #   - extend Discordrb::Commands::CommandContainer
  # @param klass [Symbol, #to_sym] the name of the module
  # @param path [String] the path underneath `src/modules/` to load files from
  # "src/modules/#{path}/**/*.rb" loads from all subfolders and the main folder
  def self.load_modules(klass, path)
    new_module = Module.new
    const_set(klass.to_sym, new_module)
    Dir["src/modules/#{path}/**/*.rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:DiscordEvents, 'events')
  load_modules(:DiscordCommands, 'commands')

  # Run the bot
  BOT.run
end
