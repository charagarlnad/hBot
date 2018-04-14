module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer

    leftarrow = "\u2b05"
    rightarrow = "\u27a1"
    checkmark = "\u2714"
    trashcan = "\u{1f5D1}"

    command(:search, requirements: [:in_voice, :has_arguments]) do |event, *search|
      videos = []
      index = 0
      Thread.new do
        IO.popen("youtube-dl --restrict-filenames -o \"data/musiccache/%(title)s\" --dump-json \"ytsearch8:#{search.join(' ')}\"") do |pipe|
          while output = pipe.gets
            videos << output
          end
        end
      end

      emb = event.channel.send_embed("Video #{index + 1}:", @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))

      event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: leftarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, leftarrow)
        if index - 1 >= 0
          index -= 1
          emb.edit("Video #{index + 1}:", @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))
        else
          emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))
        end
        false
      end

      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: rightarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, rightarrow)
        if index + 1 <= 7
          index += 1
          emb.edit("Video #{index + 1}:", @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))
        else
          emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))
        end
        false # false keeps alive the await
      end

      event.bot.add_await(:"reactcheckmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: checkmark, from: event.author, message: emb) do
        emb.edit('Ok, adding video:', @newemb.call(event, 0x7289DA, @query.call(videos, event, false, true, index)))

        event.bot.awaits.except!(:"reactleft#{emb.id}", :"reactright#{emb.id}", :"reactdelete#{emb.id}", :"reactcheckmark#{emb.id}")

        add_video(event, @query.call(videos, event, false, true, index))

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
