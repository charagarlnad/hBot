module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:help, type: :General, description: 'Get a list of the bots commands.') do |event|
      event.channel.send_embed do |embed|
        commandhash = Hash.new { |h, k| h[k] = [] }
        event.bot.commands.each do |name, command|
          commandhash[command.attributes[:type]] << [name, command]
        end
        commandhash.each do |key, commands|
          commandlist = ''
          commands.each do |command|
            commandlist << "**#{event.bot.prefix}#{command[0]}**#{command[1].attributes[:description] ? " - #{command[1].attributes[:description]}" : ''}\n"
          end
          embed.add_field(name: key, value: commandlist)
        end
        embed.title = '**Imgbot (click me to invite me to your server!)**'
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.url = event.bot.invite_url
        embed.color = $normalcolor
      end
    end
  end
end
