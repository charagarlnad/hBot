module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:volume, requirements: [:in_voice, :playing, :has_arguments, :arguments_is_int], type: :Music, description: 'Set the volume to [**X**]%.') do |event, vol|
      event.voice.volume = vol.to_i * 0.01
      event.send_timed_embed do |e|
        e.description = "Ok, set the volume to #{vol.to_i}%"
        e.color = $normalcolor
      end
    end
  end
end
