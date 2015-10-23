require 'rubygems'
require 'telegram/bot'
require 'yaml'

token = ENV['API_TOKEN']
# quotes = YAML.load_file('quotes.yml')
$h = {}

class MessageParser
  @@quote_file = 'quotes.yml'
  @@quotes = YAML.load_file(@@quote_file)

  def self.rewrite_quotes_file
    File.open(@@quote_file, 'w') do |h|
      h.write @@quotes.to_yaml
    end
  end

  def self.get_random_quote
    author = @@quotes.keys.sample
    statement = @@quotes[author].sample
    "#{author}: \n #{statement}"
  end

  def self.add_to_quotes(author, phrase)
    @@quotes[author] = [] unless @@quotes.keys.include? author
    @@quotes[author] << phrase
    self.rewrite_quotes_file
  end

  def self.handle_quotes(bot,message)
    p 'parsing quotes'

    message_arr = message.text.split
    case message_arr[0]
    when "/qotd"
      bot.api.send_message(chat_id: message.chat.id, text: self.get_random_quote)
    when "/qotd_add"
      message.text.slice! "/qotd_add"
      author_raw = /<.+>/.match(message.text).to_s
      message.text.slice! author_raw.to_s
      message.text.slice " "

      author = author_raw[1..-2]
      phrase = message.text[1..-1]
      self.add_to_quotes(author, phrase)
      bot.api.send_message(chat_id: message.chat.id, text: "Quote added! \n#{author}: #{message}")
    end
  end

  def self.parse_commands(bot, message)
    p 'parsing commands'

    case message.text
    when /^\/start/
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when /^\/end/
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when /^\/qotd/
      # bot.api.send_message(chat_id: message.chat.id, text: get_random_quote)
      handle_quotes(bot,message)
    when /^\/wishlist/
      bot.api.send_message(chat_id: message.chat.id, text: "Link to feature wishlist: https://goo.gl/NZCgwB")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I'm sorry #{message.from.first_name}, I'm afraid I can't do that.")
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
