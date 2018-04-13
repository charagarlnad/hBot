module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer

    leftarrow = "\u2b05"
    rightarrow = "\u27a1"
    checkmark = "\u2714"
    trashcan = "\u{1f5D1}"

    command :search do |event, *search|
      if catch_args(event, :in_voice, :has_arguments)
        videos = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').take(8)
        index = 0
        query = lambda { 
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
          video[:location] = "data/musiccache/#{`youtube-dl --restrict-filenames --get-filename -o "%(title)s" #{video[:url]}`.chomp}.mp4"
          video
        }

        emb = event.channel.send_embed("Video #{index + 1}:", @newemb.call(event, 0x7289DA, query.call))

        event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: leftarrow, from: event.author, message: emb) do
          emb.delete_reaction(event.author, leftarrow)
          if index - 1 >= 0
            index -= 1
            emb.edit("Video #{index + 1}:", @newemb.call(event, 0x7289DA, query.call))
          else
            emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, 0x7289DA, query.call))
          end
          false
        end

        event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: rightarrow, from: event.author, message: emb) do
          emb.delete_reaction(event.author, rightarrow)
          if index + 1 <= 7
            index += 1
            emb.edit("Video #{index + 1}:", @newemb.call(event, 0x7289DA, query.call))
          else
            emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, 0x7289DA, query.call))
          end
          false # false keeps alive the await
        end

        event.bot.add_await(:"reactcheckmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: checkmark, from: event.author, message: emb) do
          emb.edit('Ok, adding video:', @newemb.call(event, 0x7289DA, query.call))

          event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")

          add_video(event, query.call)

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
