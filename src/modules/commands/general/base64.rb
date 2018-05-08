module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:base64, type: :General, requirements: [:has_arguments], description: '[**Encode or Decode**] base64 representation of a [**string**].') do |event, *args|
      hash =
        if ['encode', 'decode'].include? args.first
          type = args.shift
          if type == 'encode'
            Base64.encode64(args.join(' '))
          elsif type == 'decode'
            Base64.decode64(args.join(' '))
          end
        else
          Base64.encode64(args.join(' '))
        end
      event.channel.send_embed do |embed|
        embed.description = hash
      end
    end
  end
end
