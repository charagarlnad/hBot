module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    youtube = Magick::Image.read('data/command_data/youtube/source.png').first
    youtube_mask = Magick::Image.read('data/command_data/youtube/mask.png').first.negate
    youtube_mask.matte = false
    command(:youtube, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.scale(600, 400)

      append_image.composite!(youtube_mask, Magick::CenterGravity, 600, 20, Magick::CopyOpacityCompositeOp)
      result = youtube.composite(append_image, Magick::CenterGravity, -600, -20, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(append_image.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
