# Define the method to get a image, either upload, history, mention, url, or text
module Discordrb::Events
  class MessageEvent
    def get_editimage
      if self.message.attachments.any? == false && self.message.content.split[1] == nil
        avatar = open(self.channel.history(100).select { |msg|  msg.attachments.any? }.first.attachments.first.url).read
      elsif self.message.attachments.any?
        avatar = open(self.message.attachments.first.url).read
      elsif self.message.content.split[1] != nil
        if self.message.content.split[1] =~ URI::regexp
          avatar = open(self.message.content.split[1]).read
        elsif self.message.content.split[1] =~ /<@!?\d{10,}>/
          avatar = open(self.bot.parse_mention(self.message.content.split[1]).on(self.server).avatar_url).read
        else
          canvas = Magick::ImageList.new
          canvas << Magick::Image.new(512, 512)
          canvas << Magick::Image.read("caption:#{self.message.content.split(' ')[1..-1].join(' ')}") do |caption|
           caption.pointsize = 64
           caption.size = "512x512"
           caption.background_color = "none"
           caption.gravity = Magick::CenterGravity
          end.first
          canvas.flatten_images.to_blob{  |blobbify|  blobbify.format = 'JPG' }
        end
      end
    end
  end
end
