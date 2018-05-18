# Gems
require 'yaml'
Bundler.require

# The main bot module.
# Contains many of the variables and the actual Bot instance.
module Bot
  # Get git status and check if bot is outdated.
  `git fetch`
  @local_commits = `git rev-list master`.split("\n")
  @remote_commits = `git rev-list origin/master`.split("\n")
  if @local_commits.size == @remote_commits.size
    puts "You are running the latest version of hBot, commit #{@local_commits.first}."
  elsif @local_commits.size <= @remote_commits.size
    puts "You are not running the latest version of hBot, local copy @ commit #{@local_commits.first}, github @ #{@remote_commits.first}. Run the update command to update."
  else
    puts "You are running a non-existent version of hBot, local copy @ commit #{@local_commits.first}, github @ #{@remote_commits.first}."
  end

  # Define all variables and use a hacky way to expose them as 'instance variables' in a module.
  @messages = 0
  @embedtimeout = 30
  @normalcolor = 0x7289DA
  @othercolor = 0x89DA72
  @errorcolor = 0xDA7289
  @leftarrow = '⬅'.freeze
  @rightarrow = '➡'.freeze
  @checkmark = '✔'.freeze
  @trashcan = '🗑'.freeze
  @like = '<:likes:434777642353295371>'.freeze
  @dislike = '<:dislikes:434777663929057290>'.freeze
  @ruby = '<:ruby:436696214264741890>'.freeze
  @masterqueue = Hash.new { |h, k| h[k] = [] }
  @ytdl_host = Process.spawn('python3 ytdl_host.py')

  class << self
    [:messages, :embedtimeout, :normalcolor, :othercolor, :errorcolor, :leftarrow, :rightarrow, :checkmark, :trashcan, :like, :dislike, :ruby, :masterqueue, :ytdl_host, :local_commits, :remote_commits].each do |var|
      attr_accessor var
    end
  end

  # Load non-Discordrb modules
  Dir['src/modules/*.rb'].each { |mod| load mod }
  puts 'Loaded mods'

  # Bot configuration
  unless File.file?('data/config.yaml')
    puts 'You didn\'t make a config file! Make the config file and start the bot again.'
    Process.kill 'TERM', @ytdl_host
    exit!
  end
  CONFIG = (YAML.load_file 'data/config.yaml').symbolize_keys.freeze
  puts 'Loaded config'

  # Create the bot.
  # The bot is created as a constant, so that you
  # can access the cache anywhere.
  HBOT = Discordrb::Commands::CommandBot.new(token: CONFIG[:token], prefix: CONFIG[:prefix], help_available: false) # log_mode: :debug

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
    # Creates a new base module Bot::
    new_module = Module.new
    # And then set it to DiscordEvents/DiscordCommands
    const_set(klass.to_sym, new_module)
    # Then load in each ruby file, which will be included into that module because they all are module Bot::DiscordCommands
    Dir["src/modules/#{path}/**/*.rb"].each { |file| load file }
    # And finally loop through each submodule IE fun, music
    new_module.constants.each do |mod|
      HBOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:DiscordEvents, 'events')
  load_modules(:DiscordCommands, 'commands')

  # Run the bot
  HBOT.run
end
