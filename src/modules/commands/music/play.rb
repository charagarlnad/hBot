module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :play do |event, *search|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif search.empty?
        emb = event.channel.send_embed do |e|
          e.description = 'A search is required.'
          e.color = 0x7289DA
        end
      else
        video = {}
        if search.size == 1 && search.first.include?('http') && !search.first.include?('youtube.com')
          if `youtube-dl -j #{search.first}`.chomp == ''
            emb = event.channel.send_embed do |e|
              e.description = 'Invalid url.'
              e.color = 0x7289DA
            end

            sleep(@embedtimeout)
            emb.delete
            break
          end
          video[:description] = 'N/A'
          video[:title] = `youtube-dl --get-filename -o "%(title)s" #{search.first}`
          video[:url] = search.first
          video[:thumbnail_url] = event.bot.profile.avatar_url
          video[:like_count] = 'N/A'
          video[:dislike_count] = 'N/A'
          video[:comment_count] = 'N/A'
          video[:view_count] = 'N/A'
          video[:length] = `youtube-dl -j #{search.first} | jq .duration`
        else
          query = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').first

          sleep(0.05) while query.title.nil?

          video[:description] = query.description
          video[:title] = query.title
          video[:url] = 'https://www.youtube.com/watch?v=' + query.id
          video[:thumbnail_url] = query.thumbnail_url
          video[:like_count] = query.like_count
          video[:dislike_count] = query.dislike_count
          video[:comment_count] = query.comment_count
          video[:view_count] = query.view_count
          video[:length] = query.length
        end

        emb = event.channel.send_embed('Ok, adding to queue:') do |e|
          e.title = video[:title]
          e.description = video[:description]
          e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{video[:like_count]} Likes, #{video[:dislike_count]} Dislikes, #{video[:view_count]} Views, #{video[:comment_count]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
          e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url])
          e.url = video[:url]
          e.color = 0x7289DA
        end

        add_video(event, video)
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
