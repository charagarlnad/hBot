module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:resume, requirements: [:in_voice, :playing], type: :Music, description: 'Unpause the currently playing video.') do |event|
      event.voice.continue
      event.send_timed_embed do |e|
        e.description = 'Ok, resumed the video.'
      end
    end
  end
end
