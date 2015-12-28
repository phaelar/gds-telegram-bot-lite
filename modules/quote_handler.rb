require 'rubygems'
require 'telegram/bot'

require './models/quote'

class QuoteHandler

  def self.get_random_quote
    total_quotes = Quote.count
    if total_quotes >= 1
      chosen = Quote.offset(rand(total_quotes)).first
      "#{chosen.author}: \n #{chosen.phrase}"
    else
      "Sorry, there are no quotes yet!"
    end
  end

  def self.add_to_quotes(author, phrase)
    Quote.create(author: author, phrase: phrase, sensitive: false)
  end

  def self.handle_quotes(bot,message)
    p 'parsing quotes'

    message_arr = message.text.split
    case message_arr[0]
    when "/qotd"
      bot.api.send_message(chat_id: message.chat.id, text: self.get_random_quote)
    when "/qotd_add"
      if message.chat.type != "private"
        bot.api.send_message(chat_id: message.chat.id, text: "Please send me a PM to add a new quote!")
      else
        message.text.slice! "/qotd_add"
        begin
          author_raw = /<.+>/.match(message.text).to_s
          message.text.slice! author_raw.to_s
          message.text.slice " "

          author = author_raw[1..-2]
          phrase = message.text[1..-1]
          raise Exception if (author.length == 0 || phrase.length == 0)
          self.add_to_quotes(author, phrase)
          bot.api.send_message(chat_id: message.chat.id, text: "Quote added! \n#{author}: #{message.text}")
        rescue Exception => e
          bot.api.send_message(chat_id: message.chat.id, text: "Sorry a formatting error occured! Please use this format: '/qotd_add <author> message'")
        end
      end
    end
  end
end
