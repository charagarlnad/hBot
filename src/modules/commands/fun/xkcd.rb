module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    max_num = JSON.parse(Net::HTTP.get(URI('https://xkcd.com/info.0.json')))['num']
    command(:xkcd, type: :Fun, description: 'Get the latest, random, or [**X**] xkcd comic.') do |event, opts|
      url =
        if opts.nil?
          'https://xkcd.com/info.0.json'
        elsif opts.i? && opts.to_i <= max_num
          "https://xkcd.com/#{opts}/info.0.json"
        else
          "https://xkcd.com/#{rand(0..max_num)}/info.0.json"
        end
      info = JSON.parse(Net::HTTP.get(URI(url))).symbolize_keys
      event.channel.send_embed do |embed|
        embed.title = info[:safe_title]
        embed.url = url.sub('info.0.json', '')
        embed.description = info[:alt]
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: info[:img])
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{info[:year]}-#{info[:month]}-#{info[:day]} \##{info[:num]}")
      end
      nil
    end
  end
end
