require 'active_record'

class Message < ActiveRecord::Base
  belongs_to :hashtag
end
