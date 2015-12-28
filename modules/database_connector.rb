require 'active_record'
require 'logger'

class DatabaseConnector
  class << self
    def establish_connection
      #debug log path
      ActiveRecord::Base.logger = Logger.new('debug.log')

      #database config path
      configuration = YAML::load(IO.read('config/database.yml'))

      ActiveRecord::Base.establish_connection(configuration)
    end
  end
end
