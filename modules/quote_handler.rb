require 'rubygems'
require 'telegram/bot'

require './models/quote'

class QuoteHandler
  def self.get_random_quote
    quote = $developer_quotes[rand(0..$developer_quotes.length-1)]
    "\"#{quote['text']}\" - #{quote['author']}"
  end

  def self.get_random_gds_quote
    total_quotes = Quote.count
    if total_quotes >= 1
      chosen = Quote.offset(rand(total_quotes)).first
      "\"#{chosen.phrase}\" - #{chosen.author}"
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
    when "/qotd", "/qotd@#{$bot_name}"
      bot.api.send_message(chat_id: message.chat.id, text: self.get_random_quote)
    when "/qotd_gds", "/qotd_gds@#{$bot_name}"
      bot.api.send_message(chat_id: message.chat.id, text: self.get_random_gds_quote)
    when "/qotd_gds_add", "/qotd_gds_add@#{$bot_name}"
      if message.chat.type != "private"
        bot.api.send_message(chat_id: message.chat.id, text: "Please send me a PM to add a new quote!")
      else
        message_text = message.text
        message_text.slice! "/qotd_gds_add"
        message_text.slice! "@#{$bot_name}"
        begin
          author_raw = /<.+>/.match(message_text).to_s
          message_text.slice! author_raw.to_s
          message_text.slice " "

          author = author_raw[1..-2]
          phrase = message_text[1..-1]
          raise Exception if (author.length == 0 || phrase.length == 0)
          self.add_to_quotes(author, phrase)
          bot.api.send_message(chat_id: message.chat.id, text: "Quote added! \n#{author}: #{message_text}")
        rescue Exception => e
          bot.api.send_message(chat_id: message.chat.id, text: I18n.t('quotes.formatting_error'))
        end
      end
    end
  end
end
