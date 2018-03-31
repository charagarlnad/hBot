module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command :stats do |event|
      ping = ((Time.now - event.timestamp) * 1000).to_i
      event << "Ping: #{ping}ms."

      total_size = 0
      Dir["data/musiccache/*"].each do |f|
        total_size += File.size(f) if File.file?(f) && File.size?(f)
      end
      event << "Music cache size: #{Filesize.from(total_size.to_s + ' B').pretty}"
      
    end
  end
end
