module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:search, requirements: [:in_voice, :has_arguments], type: :Music, description: 'Search for a [**Video/Search**] to add to the music queue.') do |event, *search|
      videos = []
      index = 0
      Thread.new do
        IO.popen("youtube-dl --restrict-filenames -o \"data/musiccache/%(title)s\" --dump-json \"ytsearch8:#{search.join(' ')}\"") do |pipe|
          pipe.each do |video|
            videos << video
          end
        end
      end

      emb = event.channel.send_embed("Video #{index + 1}:", @newemb.call(event, video: @query.call(videos, event, index: index)))

      event.bot.add_await(:"leftarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: $leftarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, $leftarrow)
        if index - 1 >= 0
          index -= 1
          emb.edit("Video #{index + 1}:", @newemb.call(event, video: @query.call(videos, event, index: index)))
        else
          emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, video: @query.call(videos, event, index: index)))
        end
        false
      end

      event.bot.add_await(:"rightarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: $rightarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, $rightarrow)
        if index + 1 <= 7
          index += 1
          emb.edit("Video #{index + 1}:", @newemb.call(event, video: @query.call(videos, event, index: index)))
        else
          emb.edit("Video #{index + 1} (no more videos):", @newemb.call(event, video: @query.call(videos, event, index: index)))
        end
        false # false keeps alive the await
      end

      event.bot.add_await(:"checkmark#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: $checkmark, from: event.author, message: emb) do
        emb.edit('Ok, adding video:', @newemb.call(event, video: @query.call(videos, event, index: index)))

        event.bot.awaits.except!(:"leftarrow#{emb.id}", :"rightarrow#{emb.id}", :"checkmark#{emb.id}", :"trashcan#{emb.id}")

        add_video(@query.call(videos, event, index: index))

        Thread.new do # Awaits do not get the fancy proc that commands do, so you have to do this.
          sleep($embedtimeout)
          emb.delete
        end
      end

      event.bot.add_await(:"trashcan#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: $trashcan, from: event.author, message: emb) do
        event.bot.awaits.except!(:"leftarrow#{emb.id}", :"rightarrow#{emb.id}", :"checkmark#{emb.id}", :"trashcan#{emb.id}")
        emb.delete
      end

      emb.react($leftarrow)
      emb.react($rightarrow)
      emb.react($checkmark)
      emb.react($trashcan)
    end
  end
end
