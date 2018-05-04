module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:addtime, requirements: [:in_voice, :playing, :has_arguments, :arguments_is_int], type: :Music, description: 'Skip ahead [**X**] seconds.') do |event, time|
      event.voice.skip(time.to_i)
      Bot.masterqueue[event.server.id].first.skipped_time += time.to_i
      event.send_timed_embed do |e|
        e.description = "Ok, skipping #{time} seconds ahead, this may take a moment..."
      end
    end
  end
end
