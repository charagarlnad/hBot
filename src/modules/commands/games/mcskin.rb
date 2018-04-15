module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    command(:mcskin, type: :Games, description: 'Get the skin for a [**Minecraft Username**].') do |event, username|
      event.channel.send_embed do |embed|
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://visage.surgeplay.com/full/512/#{username}.png")
        embed.color = 0x7289DA
      end
    end
  end
end
