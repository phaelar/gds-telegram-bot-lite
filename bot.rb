#!/usr/bin/env ruby

require 'rubygems'
require 'telegram/bot'
require 'open-uri'

require './modules/app_configurator'
require './modules/message_parser'

config = AppConfigurator.new
config.configure
token = config.get_token
# @developer_quotes = config.fetch_developer_quotes
# p @developer_quotes.length

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
