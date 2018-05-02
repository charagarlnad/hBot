module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    crash = Magick::Image.read('data/command_data/crash/source.png').first
    crash_mask = Magick::Image.read('data/command_data/crash/mask.png').first.negate
    crash_mask.matte = false
    command(:crash, type: :'Image Editing') do |event|
      # Use pitch/skew to make this look better
      append_image = Magick::Image.from_blob(event.image_source).first.scale(500, 400)

      append_image.composite!(crash_mask, Magick::CenterGravity, 220, -40, Magick::CopyOpacityCompositeOp)
      result = crash.composite(append_image, Magick::CenterGravity, -220, 40, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
