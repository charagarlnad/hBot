module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :np do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      emb = event.channel.send_embed do |embed|
        embed.description = @masterqueue[event.server.id].first[:video].description
        embed.title = @masterqueue[event.server.id].first[:video].title
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: @masterqueue[event.server.id].first[:video].thumbnail_url)  
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{Time.at(event.voice.stream_time.to_i).utc.strftime("%H:%M:%S")}/#{@masterqueue[event.server.id].first[:video].length}")
        embed.color = 0x7289DA
      end

      Thread.new do
        sleep(32) 
        emb.delete
      end
      nil

    end
  end
end
