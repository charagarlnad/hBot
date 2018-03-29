module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :play do |event, *search|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      video = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').first
      event.channel.send_embed("Ok, adding to queue:") do |e|
        e.title = video.title
        e.description = video.description
        e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{video.like_count} Likes, #{video.dislike_count} Dislikes, #{video.view_count} Views, #{video.comment_count} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
        e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video.thumbnail_url)
        e.url = "https://www.youtube.com/watch?v=" + video.id
      end
      addQueue(video, event)
    end
  end
end
