module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :summon do |event|
      event.voice.destroy unless event.voice.nil? # it gets stuck sometimes over a reboot so this fixes it
      event.bot.voice_connect(event.user.voice_channel)

      emb = event.channel.send_embed do |e|
        e.description = "Ok, joining `#{event.user.voice_channel.name}`"
        e.color = 0x7289DA
      end

      sleep(@embedtimeout)
      emb.delete

    end
  end
end
