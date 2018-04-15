module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:np, requirements: [:in_voice, :playing], type: :Music, description: 'Get the currently playing video.') do |event|
      event.send_timed_embed('', @newemb.call(event, queue: true))
    end
  end
end
