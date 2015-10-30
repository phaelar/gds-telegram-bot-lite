require 'rubygems'
require 'telegram/bot'
require 'yaml'

class QuoteHandler
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
end
