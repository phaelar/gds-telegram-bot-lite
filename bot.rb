#!/usr/bin/env ruby

require 'rubygems'
require 'telegram/bot'
require 'open-uri'

require './modules/app_configurator'
require './modules/message_parser'

config = AppConfigurator.new
config.configure
token = config.get_token
$bot_name = ENV['TELEGRAM_BOT_NAME']

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
