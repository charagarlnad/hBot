module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:play, requirements: [:in_voice, :has_arguments_or_attachment], type: :Music, description: 'Add a [**Video/Search**] to the music queue.') do |event, *search|
      vidsearch =
        if !event.message.attachments.empty?
          event.message.attachments.first.url
        elsif search.length == 1 && search.first.start_with?('http')
          search.first
        else
          'ytsearch1:' + search.join(' ')
        end

      add_video(Video.new(request_vid(:play, vidsearch), event))

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
