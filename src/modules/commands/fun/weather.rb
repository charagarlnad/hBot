module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:weather, type: :Fun, requirements: [:has_arguments], description: 'Get the weather for [**X**].') do |event, *search|
      response = JSON.parse(Net::HTTP.get(URI("http://api.openweathermap.org/data/2.5/weather?q=#{search.join(' ')}&units=imperial&APPID=#{Bot::CONFIG[:owm_token]}")))
      event.channel.send_embed do |embed|
        embed.title = "Weather for #{response['sys']['country']}, #{response['name']}"
        embed.description = "#{response['main']['temp']}°F - #{response['weather'].first['main']}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "http://openweathermap.org/img/w/#{response['weather'].first['icon']}.png")
      end
      nil
    end
  end
end
