module Bot::DiscordCommands
  #the actual help command, may change in the future to dyanmically put commands in here by the subfolder it is in, and a tag in the file that gives the command description
  #makes this a fuckton easier, medium priority
  #calling bot itself is hard i dont want to call Bot::BOT so i guess event.bot works but investigate making BOT public
  module General
    extend Discordrb::Commands::CommandContainer
    command :help do |event|
      event.channel.send_embed do |embed|
        embed.title = '**Imgbot (click me to invite me to your server!)**'
        embed.description = "
Made with love by Chara#5143
Development Server: https://discord.gg/bvhbNVB"
        embed.add_field(name: "General", value: "
#{event.bot.prefix}help
#{event.bot.prefix}stats
    ", inline: true)
        embed.add_field(name: "Image Editing", value: "
#{event.bot.prefix}proto
#{event.bot.prefix}porn
#{event.bot.prefix}crash
#{event.bot.prefix}gone
#{event.bot.prefix}magick
#{event.bot.prefix}pixelsort (COMMAND WILL BE RESTORED SOON)
#{event.bot.prefix}ipmask
#{event.bot.prefix}trippy (COMMAND WILL BE RESTORED SOON)
#{event.bot.prefix}deepfry (COMMAND WILL BE RESTORED SOON)
#{event.bot.prefix}clickbait (COMMAND WILL BE RESTORED SOON)
#{event.bot.prefix}youtube
#{event.bot.prefix}selfie
#{event.bot.prefix}intelligence
#{event.bot.prefix}mariodelet
#{event.bot.prefix}paper
#{event.bot.prefix}protect
#{event.bot.prefix}pixelate
    ", inline: true)
    embed.add_field(name: "Games", value: "
#{event.bot.prefix}ftbwiki
#{event.bot.prefix}mojang
", inline: true)
        embed.add_field(name: "Other", value: "
#{event.bot.prefix}fakeperson
    ", inline: true)
        embed.add_field(name: "Bot Owner", value: "
#{event.bot.prefix}eval
#{event.bot.prefix}archive
    ", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.url = event.bot.invite_url
        embed.color = 7440596
      end
    end
  end
end
