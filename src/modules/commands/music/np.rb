module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :np do |event|
      emb = if event.voice.nil?
        event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        event.channel.send_embed do |e|
          e.description = 'There is nothing playing.'
          e.color = 0x7289DA
        end
      else
        event.channel.send_embed do |embed|
          embed.add_field(name: 'Added by:', value: event.user.name)
          embed.description = @masterqueue[event.server.id].first[:description]
          embed.title = @masterqueue[event.server.id].first[:title]
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: @masterqueue[event.server.id].first[:thumbnail_url])
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{Time.at(event.voice.stream_time.to_i).utc.strftime('%H:%M:%S')}/#{@masterqueue[event.server.id].first[:length]}")
          embed.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
