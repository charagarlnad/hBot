module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :summon do |event|
      @voicebots[event.server.id] = event.bot.voice_connect(event.user.voice_channel)
    end
  end
end
