module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:rule34, type: :General, requirements: [:nsfw], description: 'Get rule34.xxx [**search**]. Must be run in a NSFW channel.') do |event, *tags|
      search = JSON.parse(Net::HTTP.get(URI("https://rule34.xxx/index.php?page=dapi&s=post&json=1&limit=32&q=index&tags=#{tags.join('+')}"))).sample.symbolize_keys
      event.send_embed do |embed|
        embed.add_field(name: 'Score', value: search[:score], inline: true)
        embed.add_field(name: 'Tags', value: search[:tags][0..1023])
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://img.rule34.xxx/images/#{search[:directory]}/#{search[:image]}")
      end
    rescue
      event.send_embed do |embed|
        embed.description = "No results found on rule34.xxx for #{tags.join(' ')}."
        embed.color = Bot.errorcolor
      end
    end
  end
end
