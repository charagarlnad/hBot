module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:gelbooru, type: :NSFW, description: 'Get gelbooru [**search**]. Will only return SFW results unless it is run in a NSFW channel.') do |event, *tags|
      search = JSON.parse(Net::HTTP.get(URI("https://gelbooru.com/index.php?page=dapi&s=post&json=1&limit=32&q=index&tags=#{tags.join('+')}"))).map(&:symbolize_keys)
      search =
        if event.channel.nsfw
          search
        else
          search.select { |image| image[:rating] == 's' }
        end.sample
      rating =
        if search[:rating] == 's'
          'Safe'
        elsif search[:rating] == 'q'
          'Questionable'
        elsif search[:rating] == 'e'
          'Explicit'
        else
          'Unknown'
        end
      event.send_embed do |embed|
        embed.add_field(name: 'Score', value: search[:score], inline: true)
        embed.add_field(name: 'Rating', value: rating, inline: true)
        embed.add_field(name: 'Tags', value: search[:tags][0..1023])
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: search[:file_url])
      end
    rescue
      event.send_embed do |embed|
        embed.description = "No results found on gelbooru for #{tags.join(' ')}#{event.channel.nsfw ? '.' : ', use the command in a NSFW channel to get more results.'}"
        embed.color = Bot.errorcolor
      end
    end
  end
end
