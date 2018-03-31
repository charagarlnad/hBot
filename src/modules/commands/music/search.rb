module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :search do |event, *search|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      
      videos = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').take(8)
      index = 0

      newemb = lambda { Discordrb::Webhooks::Embed.new title: videos[index].title,
        description: videos[index].description, 
        footer: Discordrb::Webhooks::EmbedFooter.new(text: "#{videos[index].like_count} Likes, #{videos[index].dislike_count} Dislikes, #{videos[index].view_count} Views, #{videos[index].comment_count} Comments",
        icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'),
        thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: videos[index].thumbnail_url),
        url: "https://www.youtube.com/watch?v=" + videos[index].id }
      
      emb = event.channel.send_embed("Video #{index + 1}:", newemb.call)

      event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u2b05", from: event.author, message: emb) do |react_event|
        if index - 1 >= 0
          index -= 1
          emb.edit("Video #{index + 1}:", newemb.call)
        else
          emb.edit("Video #{index + 1} (no more videos):", newemb.call)
        end
        false
      end

      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u27a1", from: event.author, message: emb) do |react_event|
        if index + 1 <= 7
          index += 1
          emb.edit("Video #{index + 1}:", newemb.call)
        else
          emb.edit("Video #{index + 1} (no more videos):", newemb.call)
        end
        false # false keeps alive the await
      end

      event.bot.add_await(:"reactcheckmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u2714", from: event.author, message: emb) do |react_event|
        emb.edit("Ok, adding video:", newemb.call)

        addVideo(event, videos[index])

        event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")
        Thread.new do # sleep freezes the main thread, so we make a new one instead, awaits are not in here because race condition with the buttons
          sleep(5) 
          emb.delete
        end
      end

      event.bot.add_await(:"reactdelete#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u{1f5D1}", from: event.author, message: emb) do |react_event|
        event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")
        emb.delete
      end

      emb.react("\u2b05")
      emb.react("\u27a1")
      emb.react("\u2714")
      emb.react("\u{1f5D1}")

      nil # needed so it doesnt return the await to the command block
    end
  end
end