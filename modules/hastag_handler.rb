require 'rubygems'
require 'telegram/bot'

require './models/hashtag'
require './models/message'

class HashtagHandler
  def self.add_new_message(message, hashtag)
    user = "#{message.from.first_name} #{message.from.last_name}"
    m = Message.create(user: user, text: message.text, hashtag: hashtag)
  end

  def self.add_new_hashtag(hashtag_string)
    hashtag = Hashtag.create(name: hashtag_string)
    hashtag
  end

  def self.handle_hashtags(bot, message, hashtag_string)
    hashtag = Hashtag.where(name: hashtag_string.downcase).first
    hashtag = self.add_new_hashtag(hashtag_string) if hashtag.nil?
    self.add_new_message(message,hashtag)
  end

  def self.count_hashtags(bot, message)
    begin
      hashtag_string = message.text.match(/#(\w+)/).to_s
      raise Exception if hashtag_string.length < 1
      hashtag = Hashtag.find_by(name: hashtag_string)
      count = hashtag.nil? ? 0 : hashtag.messages.count
      bot.api.send_message(chat_id: message.chat.id, text: "Total number of messages with #{hashtag_string}: #{count}")
    rescue Exception => e
      bot.api.send_message(chat_id: message.chat.id, text: "Sorry a formatting error occured! Please use this format: '/hashtag_count #hashtagname")
    end
  end
end
