#!/usr/bin/env ruby

require 'rubygems'
require 'telegram/bot'
require 'open-uri'

require './modules/app_configurator'
require './modules/message_parser'

config = AppConfigurator.new
config.configure

p "Starting bot..."

Telegram::Bot::Client.run($token) do |bot|
  begin
    bot.listen do |message|
      next if message.text.nil?
      if message.text.start_with?('/')
        MessageParser.parse_commands(bot, message)
      else
        MessageParser.parse_plaintext(bot, message)
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    if e.error_code.to_s == '502'
      puts 'Telegram 502 error'
      retry
    end
  end
end
