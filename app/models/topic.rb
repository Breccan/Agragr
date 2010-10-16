class Topic < ActiveRecord::Base
  has_many :feeds
  has_many :links
end
