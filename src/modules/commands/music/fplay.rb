module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:fplay, requirements: [:in_voice, :has_arguments_or_attachment], type: :Music, description: 'Add a [**Video/Search**] with filters to the music queue.') do |event, *search|
      filters = []
      if ['bass', 'echo', 'ftempo', 'stempo'].include? search.first
        while ['bass', 'echo', 'ftempo', 'stempo'].include? search.first
          filters << search.shift
        end
        if search.empty?
          event.send_timed_embed do |embed|
            embed.description = 'A video/search is required.'
            embed.color = Bot.errorcolor
          end
          next
        end
      else
        event.send_timed_embed do |embed|
          embed.description = 'No filters were supplied.'
          embed.color = Bot.errorcolor
        end
        next
      end

      vidsearch =
        if !event.message.attachments.empty?
          event.message.attachments.first.url
        elsif search.length == 1 && search.first.start_with?('http')
          search.first
        else
          'ytsearch1:' + search.join(' ')
        end
      vid = request_vid(:play, vidsearch)
      vid[:filters] = filters
      add_video(Video.new(vid, event))
      event.send_timed_embed('Ok, adding to queue:', @newemb.call(event, video: Bot.masterqueue[event.server.id].last))
    rescue => error
      event.send_timed_embed do |embed|
        embed.description = 'Invalid file/search.'
        embed.add_field(name: 'Tell a developer:', value: "#{error.class};\n#{error}", inline: true)
        embed.add_field(name: 'Backtrace:', value: "```#{error.backtrace.join("\n")[0..1023]}```", inline: true)
        embed.color = Bot.errorcolor
      end
    end
  end
end
