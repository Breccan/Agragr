class Link < ActiveRecord::Base
  belongs_to :topic
  has_many :listings
end
