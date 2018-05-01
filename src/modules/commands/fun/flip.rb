module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:flip, type: :Fun, description: 'Flip a coin.') do |event|
      event.channel.send_embed do |embed|
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: rand(2) == 0 ? 'http://www.virtualcointoss.com/img/quarter_front.png' : 'http://www.virtualcointoss.com/img/quarter_back.png')
      end
      nil
    end
  end
end
