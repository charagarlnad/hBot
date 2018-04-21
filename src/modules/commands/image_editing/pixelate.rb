module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:pixelate, type: :'Image Editing') do |event|
      canvas = Magick::Image.from_blob(event.image_source).first.scale(16, 16).scale(1024, 1024)

      upload = Tempfile.new(['hBot', '.png'])
      canvas.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!

      nil
    end
  end
end
