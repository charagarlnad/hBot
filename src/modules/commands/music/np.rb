module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :np do |event|
      event.respond 'I am not in voice.' if event.voice.nil?
      next if event.voice.nil?
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      emb = event.channel.send_embed do |embed|
        embed.description = @masterqueue[event.server.id].first[:description]
        embed.title = @masterqueue[event.server.id].first[:title]
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: @masterqueue[event.server.id].first[:thumbnail_url])
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{Time.at(event.voice.stream_time.to_i).utc.strftime('%H:%M:%S')}/#{@masterqueue[event.server.id].first[:length]}")
        embed.color = 0x7289DA
      end

      sleep(32)
      emb.delete

    end
  end
end
