module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:clearcache, type: :Owner, description: 'Clear the music bot cache.', requirements: [:owner]) do |event|
      Dir.mkdir('data/musiccache/') unless File.directory?('data/musiccache/')
      Pathname.new('data/musiccache/').children.each(&:unlink)
      event.respond 'Cache cleared!'
    end
  end
end
