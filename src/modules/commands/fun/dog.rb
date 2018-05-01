module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:dog, type: :Fun, description: 'Get a random dog.') do |event|
      event.channel.send_embed do |embed|
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: JSON.parse(Net::HTTP.get(URI('https://dog.ceo/api/breeds/image/random')))['message'])
      end
      nil
    end
  end
end
