require 'logger'
require './modules/database_connector'
require 'yaml'

class AppConfigurator
  def configure
    read_from_config
    fetch_developer_quotes
    setup_i18n
    setup_database
  end

  def read_from_config
    config = YAML.load_file('config/secrets.yml')
    $token = config['TELEGRAM_BOT_TOKEN']
    $bot_name = config['TELEGRAM_BOT_NAME']
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end

  def fetch_developer_quotes
    begin
      $developer_quotes = JSON.parse(open("https://cdn.rawgit.com/fortrabbit/quotes/master/quotes.json").read)
    rescue
      $developer_quotes = {}
    end
  end

  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
