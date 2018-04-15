module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:addtime, requirements: [:in_voice, :playing, :arguments_is_int], type: :Music, description: 'Skip ahead [**X**] seconds.') do |event, time|
      event.voice.skip(time.to_i)
      event.send_timed_embed do |e|
        e.description = "Ok, skipped #{time} seconds ahead."
        e.color = $normalcolor
      end
    end
  end
end
