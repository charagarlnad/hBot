module Bot::DiscordCommands
  module General
      extend Discordrb::Commands::CommandContainer
      command :help do |event|
        #if you're going to be writing your own help command, the current list of loaded commands can be accessed in the event via event.bot.commands. It's a hash of command name to command object. From there, command.attributes is the attributes hash where you can tap into the commands description, etc
        event.channel.send_embed do |embed|
          Dir["src/modules/commands/**"].each do |base|
            commandarr = Dir.children(base).map { |prepend| "#{event.bot.prefix}#{prepend}" } #ruby 2.3 or above boys
            embed.add_field(name: base, value: commandarr.join("\n").gsub('.rb', ''))
          end
          embed.title = '**Imgbot (click me to invite me to your server!)**'
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
          embed.url = event.bot.invite_url
          embed.color = 7440596
        end
      end
  end
end