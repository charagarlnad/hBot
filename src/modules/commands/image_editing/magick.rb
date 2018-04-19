module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:magick, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.scale(800, 800).liquid_rescale(400, 400, 1, 0).liquid_rescale(1000, 1000, 2, 0)

      upload = Tempfile.new(['imgbot', '.png'])
      append_image.write(upload.path)
      event.channel.send_file upload

      upload.close!
      append_image.destroy!

      nil
    end
  end
end
