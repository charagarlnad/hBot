module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :search do |event, *search|
      query = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance')
      index = 0
      videos = []

      query.take(5).each do |video|
        videos << video
      end
      
      emb = event.channel.send_embed("Video #{index + 1}:") do |e|
        e.title = videos[index].title
        e.description = videos[index].description
        e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{videos[index].like_count} Likes, #{videos[index].dislike_count} Dislikes, #{videos[index].view_count} Views, #{videos[index].comment_count} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
        e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: videos[index].thumbnail_url)
        e.url = "https://www.youtube.com/watch?v=" + videos[index].id
      end

      newemb = lambda { Discordrb::Webhooks::Embed.new title: videos[index].title,
      description: videos[index].description, 
      footer: Discordrb::Webhooks::EmbedFooter.new(text: "#{videos[index].like_count} Likes, #{videos[index].dislike_count} Dislikes, #{videos[index].view_count} Views, #{videos[index].comment_count} Comments",
      icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'),
      thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: videos[index].thumbnail_url),
      url: "https://www.youtube.com/watch?v=" + videos[index].id }

      emb.react("\u2b05")
      event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u2b05") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if index - 1 >= 0
          index -= 1
          emb.edit("Video #{index + 1}:", newemb.call)
        else
          emb.edit("Video #{index + 1} (no more videos):", newemb.call)
        end
        false
      end

      emb.react("\u27a1")
      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u27a1") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if index + 1 <= 4
          index += 1
          emb.edit("Video #{index + 1}:", newemb.call)
        else
          emb.edit("Video #{index + 1} (no more videos):", newemb.call)
        end
        false # false keeps alive the await
      end

      emb.react("\u2714")
      event.bot.add_await(:"reactcheckmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u2714") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        emb.edit("Ok, adding video:", newemb.call)

        addQueue(videos[index], event)

        event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")
        Thread.new do # sleep freezes the main thread, so we make a new one instead, awaits are not in here because race condition with the buttons
          sleep(5) 
          emb.delete
        end
      end

      emb.react("\u{1f5D1}")
      event.bot.add_await(:"reactdelete#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u{1f5D1}") do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id # can we remove this by adding more parameters to the add_await?
        event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")
        emb.delete
      end

      nil # needed so it doesnt return the await to the command block
    end
  end
end