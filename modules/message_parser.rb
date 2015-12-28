require 'rubygems'
require 'telegram/bot'
require_relative 'quote_handler'
require_relative 'hastag_handler'

class MessageParser

  def self.parse_commands(bot, message)
    p 'parsing commands'

    case message.text
    when /^\/start/
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when /^\/end/
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when /^\/qotd/
      QuoteHandler.handle_quotes(bot,message)
    when /^\/hashtag_count/
      HashtagHandler.count_hashtags(bot,message)
    when /^\/wishlist/
      bot.api.send_message(chat_id: message.chat.id, text: "Link to feature wishlist: https://goo.gl/NZCgwB")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I'm sorry #{message.from.first_name}, I'm afraid I can't do that.")
    end
  end

  def self.parse_plaintext(bot, message)
    if !message.text.match(/^#\w+|/).to_s.empty? #message starts with hashtag
      hashtag_string = message.text.match(/^#\w+|/).to_s
    elsif !message.text.match(/#(\w+)/).to_s.empty? #message contains a hashtag
      hashtag_string = message.text.match(/#(\w+)/).to_s
    end

    if !(hashtag_string.nil? || hashtag_string.empty?)
      HashtagHandler.handle_hashtags(bot,message,hashtag_string)
    end

  end
end
