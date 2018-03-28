module Bot::DiscordCommands
  module Other
    extend Discordrb::Commands::CommandContainer
    command :fakeperson do |event|
      search = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance')
      index = 0
      event.channel.send_embed do |e|
        e.title = "#{search[index].title}"
        e.description = "#{search[index].description}"
        e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index].like_count} Likes, #{search[index].dislike_count} Dislikes, #{search[index].view_count} Views, #{search[index].comment_count} Comments", icon_url: 'https://www.youtube.com/yt/brand/media/image/YouTube-icon-full_color.png')
        e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: search[index].thumbnail_url)
        e.url = "https://www.youtube.com/watch?v=#{search[index].id}"
      end
      event.respond "Is this the video you want? Y/n"
      event.message.await(:response) do |response_event|
        if response_event.message.content.downcase == 'y'
          response_event.respond 'ok, adding video!'
        else
          response_event.respond 'not adding video!'
        end
      end
      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u27a1") do |react_event|
        index += 1
        event.channel.send_embed do |e|
          e.title = "#{search[index].title}"
          e.description = "#{search[index].description}"
          e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{search[index].like_count} Likes, #{search[index].dislike_count} Dislikes, #{search[index].view_count} Views, #{search[index].comment_count} Comments", icon_url: 'https://www.youtube.com/yt/brand/media/image/YouTube-icon-full_color.png')
          e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: search[index].thumbnail_url)
          e.url = "https://www.youtube.com/watch?v=#{search[index].id}"
        end
      end
    end
  end
end
  