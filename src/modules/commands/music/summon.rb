module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :summon do |event|
      event.bot.voice_connect(event.user.voice_channel)
      event.respond 'Ok, joining ' + event.user.voice_channel.name + '.'
      nil
    end
  end
end
