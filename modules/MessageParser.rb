require 'rubygems'
require 'telegram/bot'
require 'yaml'
require_relative './QuoteHandler'

class MessageParser

  def self.parse_commands(bot, message)
    p 'parsing commands'

    case message.text
    when /^\/start/
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when /^\/end/
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when /^\/qotd/
      # bot.api.send_message(chat_id: message.chat.id, text: get_random_quote)
      QuoteHandler.handle_quotes(bot,message)
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
