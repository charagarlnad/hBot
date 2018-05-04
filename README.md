# hBot

[![Build Status](https://img.shields.io/travis/charagarlnad/hBot.svg?style=flat-square)](https://travis-ci.org/charagarlnad/hBot) [![License](https://img.shields.io/github/license/charagarlnad/hBot.svg?style=flat-square)](https://github.com/charagarlnad/hBot/blob/master/LICENSE) [![GitHub Issues](https://img.shields.io/github/issues-raw/charagarlnad/hBot.svg?style=flat-square)](https://github.com/charagarlnad/hBot/issues) [![Discord Invite](https://img.shields.io/discord/277977592923947018.svg?logo=discord&style=flat-square&colorB=7289DA)](https://discord.gg/bvhbNVB) [![Library](https://img.shields.io/badge/discord-rb-CC0000.svg?style=flat-square)](https://github.com/meew0/discordrb) [![Ruby](https://img.shields.io/badge/ruby-2.5-CC0000.svg?style=flat-square)](https://www.ruby-lang.org)

#### A simple modular Discord bot made in ruby.

If you just want to add the bot to your Discord server, just [click here.](https://discordapp.com/oauth2/authorize?&client_id=349325133606813699&scope=bot)

## Installing

1. Clone the github repo.
```
git clone https://github.com/charagarlnad/hBot.git
```

2. Install [RVM](https://rvm.io/rvm/install) using Ruby >= 2.5.

3. Install libopus, libsodium, OpenCV, cowsay, FFMPEG, ImageMagick, Youtube-DL and Python3.

4. Install Bundler.

```
gem install bundler
```

5. Install the rest of the gems with Bundler.

```
bundle install
```

6. Rename data/config-template.yaml to config.yaml and fill out the required fields.

7. [Optional] Change global variables the bot uses in the main src/bot.rb file.

8. Run the bot.

```
bundle exec ruby run.rb
```