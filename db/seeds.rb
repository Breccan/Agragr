# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

['news', 'pop', 'funny', 'games', 'science', 'tech', 'code', 'hobby', 'personal'].each do |topic|
    Topic.create(:name => topic)
end

[
  {
    :name => "Hacker News",
    :url => "http://new.ycombinator.com",
    :harvest_strategy => "hn",
    :topic_name => 'tech'
  },
  { :name => "r-programming",
    :url => 'http://www.reddit.com/r/programming.json',
    :topic_name => 'code',
    :harvest_strategy => "reddit" 
  }
].each do |source|
  unless Feed.where(["name = ?", source[:name]]).first
    feed = Feed.create(:name => source[:name],
                :harvest_strategy => source[:harvest_strategy],
                :url => source[:url])
    topic = Topic.where("name = ?", source[:topic_name]).first
    feed.topic = topic
    feed.save
  end
end

#subreddits and their topics
{

  :worldnews => [

  ],

  :programming => [
    'programming', 'ruby', 'python', 'java', 'php', 'javascript', 'jquery'
  ],

  :funny => [
    'pics', 'jokes', 'funny'
  ],

  :science => [

  ],

  :hobbies => [

  ],

  :tech => [

  ],

  :entertainment => [

  ],

  :community => [

  ]

}
