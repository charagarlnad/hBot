module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:queue, requirements: [:in_voice, :queue_not_empty], type: :Music, description: 'Get the currently queued videos.') do |event|
      event.send_timed_embed do |embed|
        $masterqueue[event.server.id][0..24].each do |video|
          embed.add_field(name: video[:title], value: "#{video[:description][0..511]}\n#{video[:like_count]}#{$like} / #{video[:dislike_count]}#{$dislike}, #{video[:view_count]} Views, Length: #{seconds_to_str(video[:length])}#{', Bass Boost enabled' if video[:bassboost]}")
        end
        embed.title = "**hBot Queue** - Video time: #{seconds_to_str(event.voice.stream_time.to_i)}/#{seconds_to_str($masterqueue[event.server.id].first[:length])}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: $masterqueue[event.server.id].first[:thumbnail_url])
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{$masterqueue[event.server.id].length} videos in queue.")
      end
    end
  end
end
