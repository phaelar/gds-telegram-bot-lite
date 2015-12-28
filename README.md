# GDS telegram bot rails

Simple Telegram bot for IDA GDS!
Still work in progress!

Using the  [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) wrapper for Telegram API.


## Installation
Execute:

```shell
$ bundle
```

## Running the bot

First things first, you need to [obtain a token](https://core.telegram.org/bots#botfather) for your bot. Then add your API token as an environment variable 'API_TOKEN'

Execute:
```shell
$ rake db:create db:migrate
$ ruby bot.rb
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## Usage

`/qotd`: Return a random quote

`/qotd_add <author name> the actual quote`: Add your own quote to the list! Only works if you PM the bot. (example: `/qotd_add <Shia Labeouf> Don't let your dreams be dreams`)

`/hashtag_count #<hashtag_name>`: Returns the number of messages with the hashtag specified. (exmaple: `/hashtag_count #hype`)
