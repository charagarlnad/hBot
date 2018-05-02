module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    selfie = Magick::Image.read('data/command_data/selfie/selfie.png').first
    command(:selfie, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first

      append_image.composite!(selfie.scale(append_image.columns, append_image.columns * 0.586), Magick::SouthWestGravity, 0, 0, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(append_image.to_blob, "#{event.message.id}.png")

      append_image.destroy!

      nil
    end
  end
end
