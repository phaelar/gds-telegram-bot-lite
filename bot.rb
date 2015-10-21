require 'rubygems'
require 'telegram/bot'
require 'yaml'

token = ENV['API_TOKEN']
# quotes = YAML.load_file('quotes.yml')
$h = {}

class MessageParser
  @@quotes = YAML.load_file('quotes.yml')

  def self.get_random_quote
    author = @@quotes.keys.sample
    statement = @@quotes[author].sample
    "#{author}: \n #{statement}"
  end

  def self.parse_commands(bot, message)
    p 'parsing commands'
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when '/end'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when '/qotd'
      bot.api.send_message(chat_id: message.chat.id, text: get_random_quote)
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I'm sorry Dave, I'm afraid I can't do that.")
    end
  end

  def self.parse_plaintext(bot, message)
    p message.text
    hashtag = ''
    if /^#\w+|/.match(message.text)
      hashtag = /^#\w+|/.match(message.text).to_s
    elsif /\s#\w+/.match(message.text)
      hashtag = /\s#\w+/.match(message.text).to_s
    end

    if !hashtag.empty?
      p 'hash'
      p hashtag
      if !$h[hashtag].nil?
        $h[hashtag] += 1
      elsif $h[hashtag].nil?
        $h[hashtag] = 1
      end
    end

    p $h
  end
end

p "Starting bot..."

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    next if message.text.nil?
    if message.text.start_with?('/')
      MessageParser.parse_commands(bot, message)
    else
      MessageParser.parse_plaintext(bot, message)
    end
  end
end
