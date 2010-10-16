# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

[
  {
    :name => "Hacker News",
    :url => "http://new.ycombinator.com",
    :harvest_strategy => "hn"
  },
  { :name => "R/Programming",
    :url => 'http://www.reddit.com/r/programming.json',
    :harvest_strategy => "reddit" 
  }
].each do |source|
  unless Feed.where(["name = ?", source[:name]]).first
    Feed.create(source)
  end
end

