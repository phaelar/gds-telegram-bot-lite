require 'logger'

require './modules/database_connector'

class AppConfigurator
  def configure
    # setup_i18n
    setup_database
  end

  def get_token
    ENV['API_TOKEN']
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end

  private

  # TODO: to be added soon
  # def setup_i18n
  #   I18n.load_path = Dir['config/locales.yml']
  #   I18n.locale = :en
  #   I18n.backend.load_translations
  # end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
