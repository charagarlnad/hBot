module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:hash, type: :General, requirements: [:has_arguments], description: 'Hash a string with either [**md5, sha1, sha256, or sha512**].') do |event, *args|
      hash =
        if ['md5', 'sha1', 'sha256', 'sha512'].include? args.first
          type = args.shift
          if type == 'md5'
            Digest::MD5.hexdigest(args.join(' '))
          elsif type == 'sha1'
            Digest::SHA1.hexdigest(args.join(' '))
          elsif type == 'sha256'
            Digest::SHA256.hexdigest(args.join(' '))
          elsif type == 'sha512'
            Digest::SHA512.hexdigest(args.join(' '))
          end
        else
          Digest::MD5.hexdigest(args.join(' '))
        end
      event.channel.send_embed do |embed|
        embed.description = hash
      end
    end
  end
end
