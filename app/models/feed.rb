class Feed < ActiveRecord::Base
  belongs_to :topic
  has_many :listings
  
end
