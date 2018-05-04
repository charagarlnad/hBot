# Define the method to get a image, either upload, history, mention, url, or text
module Discordrb::Events
  class MessageEvent
    def image_source
      if message.attachments.any?
        Net::HTTP.get(URI(message.attachments.first.url))
      elsif message.content.split.size > 1
        if message.content.split[1].match?(URI::DEFAULT_PARSER.make_regexp)
          Net::HTTP.get(URI(message.content.split[1]))
        elsif message.content.split[1].match?(/<@!?\d{10,}>/)
          Net::HTTP.get(URI(bot.parse_mention(message.content.split[1]).on(server).avatar_url))
        else
          canvas = Magick::ImageList.new
          canvas << Magick::Image.new(512, 512)
          canvas << Magick::Image.read("caption:#{message.content.split(' ')[1..-1].join(' ')}") do |caption|
            caption.pointsize = 64
            caption.size = '512x512'
            caption.background_color = 'none'
            caption.gravity = Magick::CenterGravity
          end.first
          canvas.flatten_images.to_blob { |blobbify| blobbify.format = 'JPG' }
        end
      else
        Net::HTTP.get(URI(channel.history(100).detect { |msg| msg.attachments.any? }.attachments.first.url))
      end
    end
  end
end
