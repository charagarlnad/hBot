module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    butt = MediaWiki::Butt.new('http://ftb.gamepedia.com/api.php', query_limit_default: 5000, use_continuation: true)
    embed = lambda do |searchresults, pagenum, event|
      search = searchresults[pagenum]
      stats = butt.get_statistics
      # Reimplment description with https://github.com/nricciar/wikicloth/
      Discordrb::Webhooks::Embed.new.tap do |local_emb|
        local_emb.title = search
        local_emb.description = Nokogiri::HTML(Net::HTTP.get(URI("https://ftb.gamepedia.com/#{search.tr(' ', '_')}"))).search('p').inner_text[0..2047]
        local_emb.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages']} | Articles: #{stats['articles']} | Edits: #{stats['edits']} | Images: #{stats['images']} | Users: #{stats['users']} | Active users: #{stats['activeusers']}")
        local_emb.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        local_emb.url = "https://ftb.gamepedia.com/#{search.tr(' ', '_')}"
      end
    end

    command(:ftbwiki, type: :Games, description: 'Search FTB Wiki for [**X**].') do |event, *user_search|
      searchresults = butt.get_prefix_search(user_search.join(' '))
      pagenum = 0

      unless searchresults[pagenum]
        event.respond 'No search results found.'
        break
      end

      emb = event.channel.send_embed('Page 1:', embed.call(searchresults, pagenum, event))

      event.bot.add_await(:"leftarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.rightarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, Bot.rightarrow)
        if pagenum + 1 <= searchresults.size
          pagenum += 1
          emb.edit("Page #{pagenum + 1}:", embed.call(searchresults, pagenum, event))
        else
          emb.edit('You have hit the end of the search.', embed.call(searchresults, pagenum, event))
        end
        false
      end

      event.bot.add_await(:"rightarrow#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.leftarrow, from: event.author, message: emb) do
        emb.delete_reaction(event.author, Bot.leftarrow)
        if pagenum > 0
          pagenum -= 1
          emb.edit("Page #{pagenum + 1}:", embed.call(searchresults, pagenum, event))
        else
          emb.edit('You have hit the beginning of the search.', embed.call(searchresults, pagenum, event))
        end
        false
      end

      event.bot.add_await(:"trashcan#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: Bot.trashcan, from: event.author, message: emb) do
        event.bot.awaits.except!(:"leftarrow#{emb.id}", :"rightarrow#{emb.id}", :"trashcan#{emb.id}")
        emb.delete
      end

      emb.react(Bot.leftarrow)
      emb.react(Bot.rightarrow)
      emb.react(Bot.trashcan)

      nil
    end
  end
end
