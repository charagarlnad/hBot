module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer

    leftarrow = "\u2b05"
    rightarrow = "\u27a1"
    checkmark = "\u2714"
    trashcan = "\u{1f5D1}"

    command :search2 do |event, *search|
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
        #videos = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').take(8)
        videos = `youtube-dl --restrict-filenames --get-filename -o "data/musiccache/%(title)s" --dump-json \"ytsearch8:#{search.join(' ')}\"`.chomp.split("\n")
        index = 0
        currvideo = {}
        query = lambda { currvideo = JSON.parse(videos[(index * 2) + 1]).with_indifferent_access }

        newemb = lambda {
          query.call
          Discordrb::Webhooks::Embed.new title: currvideo[:title],
          description: currvideo[:description][0..500] || 'N/A',
          footer: Discordrb::Webhooks::EmbedFooter.new(text: "#{currvideo[:like_count] || 'N/A'} Likes, #{currvideo[:dislike_count] || 'N/A'} Dislikes, #{currvideo[:view_count] || 'N/A'} Views,  Comments",
          icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'),
          thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: if currvideo[:thumbnails] then currvideo[:thumbnails].first[:url] else event.bot.profile.avatar_url end),
          url: currvideo[:webpage_url] || 'N/A',
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

          video[:description] = currvideo[:description] || 'N/A'
          video[:title] = currvideo[:fulltitle] || 'N/A'
          video[:url] = currvideo[:webpage_url] || 'N/A'
          video[:thumbnail_url] = if currvideo[:thumbnails] then currvideo[:thumbnails].first[:url] else event.bot.profile.avatar_url end
          video[:like_count] = currvideo[:like_count] || 'N/A'
          video[:dislike_count] = currvideo[:dislike_count] || 'N/A'
          video[:view_count] = currvideo[:view_count] || 'N/A'
          video[:length] = currvideo[:duration] || 'N/A'
          video[:event] = event
          video[:location] = videos[(index * 2)] + '.mp4'

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
