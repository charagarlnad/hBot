module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:catfact, type: :Fun, description: 'Get a random cat fact.') do |event|
      fact = JSON.parse(Net::HTTP.get(URI('https://catfact.ninja/fact'))).symbolize_keys
      event.channel.send_embed do |embed|
        embed.description = fact[:fact]
      end
      nil
    end
  end
end
