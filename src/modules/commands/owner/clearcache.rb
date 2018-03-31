module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command :clearcache do |event|
      if event.user.id == 123927345307451392
        Pathname.new('data/musiccache/').children.each { |p| p.unlink }
        event.respond 'Cache cleared!'
      end
    end
  end
end
