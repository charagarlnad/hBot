module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:queue, requirements: [:in_voice, :queue_not_empty], type: :Music, description: 'Get the currently queued videos.') do |event|
      event.send_timed_embed do |embed|
        Bot.masterqueue[event.server.id][0..24].each do |video|
          embed.add_field(name: video[:title], value: "#{video[:description][0..511]}\n#{video[:like_count]}#{Bot.like} / #{video[:dislike_count]}#{Bot.dislike}, #{video[:view_count]} Views, Length: #{seconds_to_str(video[:length])}#{', bass boost enabled' if video[:bassboost]}")
        end
        embed.title = "**hBot Queue** - Video time: #{seconds_to_str(event.voice.stream_time.to_i + Bot.masterqueue[event.server.id].first[:skipped_time])}/#{seconds_to_str(Bot.masterqueue[event.server.id].first[:length])}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Bot.masterqueue[event.server.id].first[:thumbnail_url])
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{Bot.masterqueue[event.server.id].length} videos in queue.")
      end
    end
  end
end
