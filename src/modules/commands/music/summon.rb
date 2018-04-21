module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:summon, type: :Music, requirements: [:user_in_voice], description: 'Summon the bot into your current voice channel.') do |event|
      event.voice&.destroy
      event.bot.voice_connect(event.user.voice_channel)

      event.send_timed_embed do |e|
        e.description = "Ok, joining `#{event.user.voice_channel.name}`."
      end
    end
  end
end
