module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command :stats do |event|
      ping = ((Time.now - event.timestamp) * 1000).to_i
      event.respond "Ping: #{ping}ms."
    end
  end
end
