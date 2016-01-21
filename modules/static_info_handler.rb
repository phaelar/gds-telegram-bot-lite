require 'rubygems'
require 'telegram/bot'

class StaticInfoHandler
  def self.handle_static_info(bot, message)
    p 'parsing static info'
    case message.text
    when /^\/wishlist/
      bot.api.send_message(chat_id: message.chat.id, text: I18n.t('static_info.wishlist'))
    when /^\/chapters/
      bot.api.send_message(chat_id: message.chat.id, text: I18n.t('static_info.chapter_list'))
    end
  end
end
