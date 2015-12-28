require 'active_record'

class Hashtag < ActiveRecord::Base
  has_many :messages
end
