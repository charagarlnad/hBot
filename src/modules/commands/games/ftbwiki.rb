module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    butt = MediaWiki::Butt.new('http://ftb.gamepedia.com/api.php', query_limit_default: 5000, use_continuation: true)

    rightarrow = "\u27a1".freeze
    leftarrow = "\u2b05".freeze

    command :ftbwiki do |event, *search|
      # add a timeout before handlers are deleted and a delete button
      # I have no idea how this works, but it does
      #also in add_await, you can have multiple attributes to check http://www.rubydoc.info/github/meew0/discordrb/Discordrb/Bot#add_await-instance_method
      searchresults = butt.get_prefix_search(search.join(' '))
      pagenum = 0
      search = searchresults[pagenum]

      event.respond 'No search results found.' if search == nil #stupid hack because if we do event.respond and then next on the same line it doesnt work for whatever reason
      next if search == nil

      stats = butt.get_statistics
      s = Nokogiri::HTML(open("https://ftb.gamepedia.com/#{search.gsub(' ', '_')}"))

      emb = event.channel.send_embed("Page #{pagenum + 1}:") do |embed|
        embed.title = search
        embed.description = s.search('p').inner_text[0..2047]
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages'].to_s} | Articles: #{stats['articles'].to_s} | Edits: #{stats['edits'].to_s} | Images: #{stats['images'].to_s} | Users: #{stats['users'].to_s} | Active users: #{stats['activeusers'].to_s}")
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.url = "https://ftb.gamepedia.com/#{search.gsub(' ', '_')}"
        embed.color = 7440596
      end

      emb.react(leftarrow)
      emb.react(rightarrow)

      event.bot.add_await(:"reactright#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: rightarrow) do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if pagenum + 1 < searchresults.size
          pagenum += 1
          search = searchresults[pagenum]
          s = Nokogiri::HTML(open("https://ftb.gamepedia.com/#{search.gsub(' ', '_')}"))
          newemb = Discordrb::Webhooks::Embed.new title: search, description: s.search('p').inner_text[0..2047], footer:  Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages'].to_s} | Articles: #{stats['articles'].to_s} | Edits: #{stats['edits'].to_s} | Images: #{stats['images'].to_s} | Users: #{stats['users'].to_s} | Active users: #{stats['activeusers'].to_s}"), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url), url: "https://ftb.gamepedia.com/#{search.gsub(' ', '_')}", color: 7440596
          emb.edit("Page #{pagenum + 1}:", newemb)
        else
          newemb = Discordrb::Webhooks::Embed.new title: search, description: s.search('p').inner_text[0..2047], footer:  Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages'].to_s} | Articles: #{stats['articles'].to_s} | Edits: #{stats['edits'].to_s} | Images: #{stats['images'].to_s} | Users: #{stats['users'].to_s} | Active users: #{stats['activeusers'].to_s}"), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url), url: "https://ftb.gamepedia.com/#{search.gsub(' ', '_')}", color: 7440596
          emb.edit('You have hit the end of the search.', newemb)
        end
        false
      end

      event.bot.add_await(:"reactleft#{emb.id}", Discordrb::Events::ReactionAddEvent, emoji: leftarrow) do |react_event|
        next false unless react_event.message.id == emb.id && event.author.id == react_event.user.id
        if pagenum > 0
          pagenum -= 1
          search = searchresults[pagenum]
          s = Nokogiri::HTML(open("https://ftb.gamepedia.com/#{search.gsub(' ', '_')}"))
          newemb = Discordrb::Webhooks::Embed.new title: search, description: s.search('p').inner_text[0..2047], footer:  Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages'].to_s} | Articles: #{stats['articles'].to_s} | Edits: #{stats['edits'].to_s} | Images: #{stats['images'].to_s} | Users: #{stats['users'].to_s} | Active users: #{stats['activeusers'].to_s}"), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url), url: "https://ftb.gamepedia.com/#{search.gsub(' ', '_')}", color: 7440596
          emb.edit("Page #{pagenum + 1}:", newemb)
        else
          newemb = Discordrb::Webhooks::Embed.new title: search, description: s.search('p').inner_text[0..2047], footer:  Discordrb::Webhooks::EmbedFooter.new(text: "Pages: #{stats['pages'].to_s} | Articles: #{stats['articles'].to_s} | Edits: #{stats['edits'].to_s} | Images: #{stats['images'].to_s} | Users: #{stats['users'].to_s} | Active users: #{stats['activeusers'].to_s}"), thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url), url: "https://ftb.gamepedia.com/#{search.gsub(' ', '_')}", color: 7440596
          emb.edit('You have hit the beginning of the search.', newemb)
        end
        false
      end

      nil
    end
  end
end
