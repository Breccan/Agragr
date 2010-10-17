class Link < ActiveRecord::Base

  belongs_to :topic
  has_many :listings

  def domain
    match = self.url.match(/http[s]?:\/\/([^\/]*)/)
    return nil if !match
    subs = match[1].split('.')
    subs.shift() if subs[0] == 'www'
    subs.join('.')
  end

end
