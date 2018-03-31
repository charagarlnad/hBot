module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :summon do |event|
      event.respond 'You are not in voice.' if event.user.voice_channel == nil
      next if event.user.voice_channel == nil

      event.voice.destroy if event.voice != nil # it gets stuck sometimes over a reboot so this fixes it
      event.bot.voice_connect(event.user.voice_channel)
      event.respond "Ok, joining `#{event.user.voice_channel.name}`"
      nil
    end
  end
end
