module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    help_embed = lambda do |index, keys, commandhash|
      Discordrb::Webhooks::Embed.new.tap do |local_emb|
        local_emb.title = keys[index].to_s
        descrip = ''
        commandhash[keys[index]].each do |name, command|
          descrip << "#{Bot::HBOT.prefix}#{name}#{command.attributes[:description] ? " - #{command.attributes[:description]}" : ''}\n"
        end
        local_emb.description = descrip
      end
    end

    # This command breaks when editing a lot due to a discord bug:
    # https://trello.com/c/b1LRAZkU/1401-embed-update-with-not-yet-cached-image-mixes-fields-content
    # So, I'm going to keep it as a secondary command until the bug is fixed, then replace the old help command.
    command(:help2, type: :General, description: 'Get a list of the bots commands.') do |event|
      index = 0
      commandhash = Hash.new { |h, k| h[k] = [] }
      event.bot.commands.each do |name, command|
        commandhash[command.attributes[:type]] << [name, command]
      end

      keys = commandhash.keys

      emb = event.channel.send_embed('', help_embed.call(index, keys, commandhash))

      event.bot.add_await(:"leftarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.rightarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, Bot.rightarrow)
        if index + 1 < keys.size
          index += 1
        else
          index = 0
        end
        false
      ensure
        emb.edit('', help_embed.call(index, keys, commandhash))
      end

      event.bot.add_await(:"rightarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.leftarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, Bot.leftarrow)
        if index > 0
          index -= 1
        else
          index = keys.size - 1
        end
        false
      ensure
        emb.edit('', help_embed.call(index, keys, commandhash))
      end

      event.bot.add_await(:"trashcan#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.trashcan, from: event.author, message: emb) do
        event.bot.awaits.except!(:"leftarrow#{emb.id}", :"rightarrow#{emb.id}", :"trashcan#{emb.id}")
        emb.delete
      end

      emb.react(Bot.leftarrow)
      emb.react(Bot.rightarrow)
      emb.react(Bot.trashcan)
    end
  end
end
