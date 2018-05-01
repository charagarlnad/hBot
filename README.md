# hBot

[![Build Status](https://img.shields.io/travis/charagarlnad/hBot.svg?style=flat-square)](https://travis-ci.org/charagarlnad/hBot) [![License](https://img.shields.io/github/license/charagarlnad/hBot.svg?style=flat-square)](https://travis-ci.org/charagarlnad/hBot) [![GitHub Issues](https://img.shields.io/github/issues-raw/charagarlnad/hBot.svg?style=flat-square)](https://travis-ci.org/charagarlnad/hBot) [![Discord Invite](https://img.shields.io/discord/277977592923947018.svg?logo=discord&style=flat-square&colorB=7289DA)](https://discord.gg/bvhbNVB) [![Library](https://img.shields.io/badge/discord-rb-CC0000.svg?style=flat-square)](https://github.com/meew0/discordrb) [![Ruby](https://img.shields.io/badge/ruby-2.5-CC0000.svg?style=flat-square)](https://github.com/meew0/discordrb)

#### A simple modular Discord bot made in ruby.

If you just want to add the bot to your Discord server, just [click here.](https://discordapp.com/oauth2/authorize?&client_id=349325133606813699&scope=bot)

## Installing

1. Install [RVM](https://rvm.io/rvm/install) using Ruby >= 2.5.

2. Install libopus, libsodium, OpenCV, cowsay, FFMPEG, ImageMagick, Youtube-DL and Python3.

3. Install Bundler.

```
gem install bundler
```

4. Install the rest of the gems with Bundler.

```
bundle install
```

5. Rename data/config-template.yaml to config.yaml and fill out the required fields.

6. [Optional] Change global variables the bot uses in the main src/bot.rb file.

6. Run the bot.

```
bundle exec ruby run.rb
```