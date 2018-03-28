module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :play2 do |event, *search|
      video = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').first
      event.channel.send_embed("Ok, playing:") do |e|
        e.title = video.title
        e.description = video.description
        e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{video.like_count} Likes, #{video.dislike_count} Dislikes, #{video.view_count} Views, #{video.comment_count} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
        e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video.thumbnail_url)
        e.url = "https://www.youtube.com/watch?v=" + video.id
      end
      options = {
        format: :worst,
        continue: false,
        output: 'data/musiccache/' + video.title
      }
      YoutubeDL.download("https://www.youtube.com/watch?v=" + video.id, options)
      event.member.voice_channel.play_file('data/musiccache/' + video.title)
    end
  end
end
