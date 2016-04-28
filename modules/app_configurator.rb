require 'logger'
require './modules/database_connector'
require 'yaml'
require 'twitter'

class AppConfigurator
  def configure
    read_from_config
    fetch_developer_quotes
    fetch_50nerds_quotes
    setup_i18n
    setup_database
  end

  def read_from_config
    config = YAML.load_file('config/secrets.yml')
    $token = config['TELEGRAM_BOT_TOKEN']
    $bot_name = config['TELEGRAM_BOT_NAME']
    twitter_config = {
      consumer_key: config['TWITTER_KEY'],
      consumer_secret: config['TWITTER_SECRET']
    }
    @twitter_client = Twitter::REST::Client.new(twitter_config)
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end

  private

  def fetch_50nerds_quotes
    $tweets = []
    20.times {
      $tweets += @twitter_client.user_timeline("50nerdsofgrey", {count: 200})
    }
  end

  def fetch_developer_quotes
    begin
      $developer_quotes = JSON.parse(open("https://cdn.rawgit.com/fortrabbit/quotes/master/quotes.json").read)
    rescue
      $developer_quotes = {}
    end
  end

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
