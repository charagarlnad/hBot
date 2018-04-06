module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer

    leftarrow = "\u2b05"
    rightarrow = "\u27a1"
    checkmark = "\u2714"
    trashcan = "\u{1f5D1}"

    command :search do |event, *search|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end

        sleep(@embedtimeout)
        emb.delete
      elsif search.empty?
        emb = event.channel.send_embed do |e|
          e.description = 'A search is required.'
          e.color = 0x7289DA
        end

        sleep(@embedtimeout)
        emb.delete
      else
        videos = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').take(8)
        index = 0

        newemb = lambda {
          Discordrb::Webhooks::Embed.new title: videos[index].title,
          description: videos[index].description,
          footer: Discordrb::Webhooks::EmbedFooter.new(text: "#{videos[index].like_count} Likes, #{videos[index].dislike_count} Dislikes, #{videos[index].view_count} Views, #{videos[index].comment_count} Comments",
          icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'),
          thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: videos[index].thumbnail_url),
          url: 'https://www.youtube.com/watch?v=' + videos[index].id,
          color: 0x7289DA
        }

        emb = event.channel.send_embed("Video #{index + 1}:", newemb.call)

        event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: leftarrow, from: event.author, message: emb) do
          emb.delete_reaction(event.author, leftarrow)
          if index - 1 >= 0
            index -= 1
            emb.edit("Video #{index + 1}:", newemb.call)
          else
            emb.edit("Video #{index + 1} (no more videos):", newemb.call)
          end
          false
        end

        event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: rightarrow, from: event.author, message: emb) do
          emb.delete_reaction(event.author, rightarrow)
          if index + 1 <= 7
            index += 1
            emb.edit("Video #{index + 1}:", newemb.call)
          else
            emb.edit("Video #{index + 1} (no more videos):", newemb.call)
          end
          false # false keeps alive the await
        end

        event.bot.add_await(:"reactcheckmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: checkmark, from: event.author, message: emb) do
          emb.edit('Ok, adding video:', newemb.call)

          video = {}

          video[:description] = videos[index].description
          video[:title] = videos[index].title
          video[:url] = 'https://www.youtube.com/watch?v=' + videos[index].id
          video[:thumbnail_url] = videos[index].thumbnail_url
          video[:like_count] = videos[index].like_count
          video[:dislike_count] = videos[index].dislike_count
          video[:comment_count] = videos[index].comment_count
          video[:view_count] = videos[index].view_count
          video[:length] = videos[index].length
          video[:event] = event

          event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")

          add_video(event, video)

          sleep(@embedtimeout)
          emb.delete
        end

        event.bot.add_await(:"reactdelete#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: trashcan, from: event.author, message: emb) do
          event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")
          emb.delete
        end

        emb.react(leftarrow)
        emb.react(rightarrow)
        emb.react(checkmark)
        emb.react(trashcan)
      end
    end
  end
end
