module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :resume do |event|
      event.respond 'I am not in voice.' if event.voice.nil?
      next if event.voice.nil?
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      event.voice.continue

      emb = event.channel.send_embed do |e|
        e.description = 'Ok, resumed the video.'
        e.color = 0x7289DA
      end

      sleep(8)
      emb.delete

    end
  end
end
