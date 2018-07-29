module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    protect = Magick::Image.read('data/command_data/protect/source.png').first
    command(:protect, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.resize_to_fit(350, 250)

      result = protect.composite(append_image, Magick::CenterGravity, 0, -115, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
