module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:clearcache, type: :Owner, description: 'Clear the music bot cache.', requirements: [:owner]) do |event|
      Pathname.new('data/musiccache/').children.each(&:unlink)
      event.respond 'Cache cleared!'
    end
  end
end
