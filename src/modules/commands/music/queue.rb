module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:queue, requirements: [:in_voice, :queue_not_empty], type: :Music, description: 'Get the currently queued videos.') do |event|
      puts @newemb.call(event).methods
      event.send_timed_embed do |embed|
        $masterqueue[event.server.id][0..24].each do |videohash|
          embed.add_field(name: videohash[:title], value: "added by: #{videohash[:event].user.name}, length: #{seconds_to_str(videohash[:length])}#{', bass boost enabled' if videohash[:bassboost]}\n#{videohash[:description]}")
        end
        embed.title = "**hBot Queue** - Video time: #{seconds_to_str(event.voice.stream_time.to_i)}/#{seconds_to_str($masterqueue[event.server.id].first[:length])}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: $masterqueue[event.server.id].length.to_s + ' videos in queue.')
        embed.color = $normalcolor
      end
    end

  end
end
