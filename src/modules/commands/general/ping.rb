module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module General
    extend Discordrb::Commands::CommandContainer
    command :ping do |_event|
      'Pong!'
    end
  end
end
