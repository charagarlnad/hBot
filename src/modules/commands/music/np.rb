module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:np, requirements: [:in_voice, :playing], type: :Music, description: 'Get the currently playing video.') do |event|
      event.send_timed_embed do |embed|
        embed.add_field(name: 'Added by:', value: $masterqueue[event.server.id].first[:event].user.name, inline: true)
        embed.add_field(name: 'Bass Boost:', value: 'Enabled', inline: true) unless $masterqueue[event.server.id].first[:bassboost].nil?
        embed.description = $masterqueue[event.server.id].first[:description]
        embed.title = $masterqueue[event.server.id].first[:title]
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: $masterqueue[event.server.id].first[:thumbnail_url])
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{seconds_to_str(event.voice.stream_time.to_i)}/#{seconds_to_str($masterqueue[event.server.id].first[:length])}")
        embed.color = 0x7289DA
      end

    end
  end
end
