module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:clearcache, type: :Owner, description: 'Clear the music bot cache.') do |event|
      if event.user.id == 123927345307451392
        Pathname.new('data/musiccache/').children.each(&:unlink)
        event.respond 'Cache cleared!'
      end
    end
  end
end
