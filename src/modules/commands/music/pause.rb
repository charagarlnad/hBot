module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :pause do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      event.voice.pause
      
      emb = event.channel.send_embed() do |e|
        e.description = "Ok, paused the video."
        e.color = 0x7289DA
      end

      Thread.new do
        sleep(8) 
        emb.delete
      end

      nil
    end
  end
end
