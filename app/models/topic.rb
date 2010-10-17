class Topic < ActiveRecord::Base
  has_many :feeds
  has_many :links

  def disabled(session_values)
    session_values["topics"].include(self.id.to_s)
  end
end
