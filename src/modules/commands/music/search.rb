module Bot::DiscordCommands
  module Other
    extend Discordrb::Commands::CommandContainer
    command :search do |event, *search|
      query = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance')
      index = 0
      search = []
      query.take(5).each do |video|
        res1 = {}
        res1["video_id"] = video.id
        res1["url"] = "https://www.youtube.com/watch?v=" + video.id
        res1["thumbnail"] = video.thumbnail_url
        res1["title"] = video.title
        res1["description"] = video.description
        res1["like_count"] = video.like_count
        res1["dislike_count"] = video.dislike_count
        res1["view_count"] = video.view_count
        res1["published_at"] = video.published_at
        res1["duration"] = video.duration
        res1["comment_count"] = video.comment_count
        search << res1
      end
      
      emb = event.channel.send_embed("Video #{index + 1}:") do |e|
        e.title = "#{search[index]["title"]}"
        e.description = "#{search[index]["description"]}"
        e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index]["like_count"]} Likes, #{search[index]["dislike_count"]} Dislikes, #{search[index]["view_count"]} Views, #{search[index]["comment_count"]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
        e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: search[index]["thumbnail"])
        e.url = search[index]["url"]
      end

      emb.react("\u2b05")
      event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u2b05") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if index - 1 >= 0
          index -= 1
          newemb = Discordrb::Webhooks::Embed.new title: "#{search[index]["title"]}", description: "#{search[index]["description"]}", footer:   Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index]["like_count"]} Likes, #{search[index]["dislike_count"]} Dislikes, #{search[index]["view_count"]} Views, #{search[index]["comment_count"]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: search[index]["thumbnail"])
          emb.edit("Video #{index + 1}:", newemb)
        else
          newemb = Discordrb::Webhooks::Embed.new title: "#{search[index]["title"]}", description: "#{search[index]["description"]}", footer:   Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index]["like_count"]} Likes, #{search[index]["dislike_count"]} Dislikes, #{search[index]["view_count"]} Views, #{search[index]["comment_count"]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: search[index]["thumbnail"])
          emb.edit("Video #{index + 1} (no more videos):", newemb)
        end
        false
      end

      emb.react("\u27a1")
      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u27a1") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if index + 1 <= 4
          index += 1
          newemb = Discordrb::Webhooks::Embed.new title: "#{search[index]["title"]}", description: "#{search[index]["description"]}", footer:   Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index]["like_count"]} Likes, #{search[index]["dislike_count"]} Dislikes, #{search[index]["view_count"]} Views, #{search[index]["comment_count"]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: search[index]["thumbnail"])
          emb.edit("Video #{index + 1}:", newemb)
        else
          newemb = Discordrb::Webhooks::Embed.new title: "#{search[index]["title"]}", description: "#{search[index]["description"]}", footer:   Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index]["like_count"]} Likes, #{search[index]["dislike_count"]} Dislikes, #{search[index]["view_count"]} Views, #{search[index]["comment_count"]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: search[index]["thumbnail"])
          emb.edit("Video #{index + 1} (no more videos):", newemb)
        end
        false # false keeps alive the await
      end

      emb.react("\u{1f5D1}")
      event.bot.add_await(:"reactdelete#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u{1f5D1}") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        event.bot.awaits.delete(:"reactleft#{emb.id}")
        event.bot.awaits.delete(:"reactright#{emb.id}")
        event.bot.awaits.delete(:"reactdelete#{emb.id}")
        emb.delete
      end

      nil # needed so it doesnt return the await to the command block
    end
  end
end