module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :summon do |event|
      event.voice.destroy if event.voice != nil # it gets stuck sometimes over a reboot so this fixes it
      event.bot.voice_connect(event.user.voice_channel)
      event.respond "Ok, joining `#{event.user.voice_channel.name}`"
      nil
    end
  end
end
