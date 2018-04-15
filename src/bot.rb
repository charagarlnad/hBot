# Gems
require 'yaml'
require 'open-uri'

require 'discordrb'
require 'rmagick'
require 'opencv'
require 'faker'
require 'mediawiki-butt'
require 'nokogiri'
require 'streamio-ffmpeg'
require 'filesize'
require 'active_support/core_ext/hash'

# The main bot module.
module Bot
  # Load non-Discordrb modules
  Dir['src/modules/*.rb'].each { |mod| load mod }

  # Bot configuration
  CONFIG = (YAML.load_file 'data/config.yaml').with_indifferent_access.freeze

  $embedtimeout = 30.freeze
  $leftarrow = '⬅'.freeze
  $rightarrow = '➡'.freeze
  $checkmark = '✔'.freeze
  $trashcan = '🗑'.freeze
  $like = '<:likes:434777642353295371>'.freeze
  $dislike = '<:dislikes:434777663929057290>'.freeze
  $normalcolor = 0x7289DA.freeze
  $othercolor = 0x89DA72.freeze
  $errorcolor = 0xDA7289.freeze

  # Create the bot.
  # The bot is created as a constant, so that you
  # can access the cache anywhere.
  BOT = Discordrb::Commands::CommandBot.new(client_id: CONFIG[:client_id], token: CONFIG[:token], prefix: CONFIG[:prefix], help_available: false) # log_mode: :debug

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
