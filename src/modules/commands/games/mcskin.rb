module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    command :mcskin do |event, username|
      event.respond "https://visage.surgeplay.com/full/512/#{username}.png"
    end
  end
end
