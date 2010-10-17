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
    :topic_name => 'tech',
    :type => 'ynews'
  },
  { :name => "r-programming",
    :url => 'http://www.reddit.com/r/programming.json',
    :topic_name => 'code',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-ruby",
    :url => 'http://www.reddit.com/r/ruby.json',
    :topic_name => 'code',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-iama",
    :url => 'http://www.reddit.com/r/iama.json',
    :topic_name => 'personal',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-self",
    :url => 'http://www.reddit.com/r/self.json',
    :topic_name => 'personal',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-worldnews",
    :url => 'http://www.reddit.com/r/worldnews.json',
    :topic_name => 'news',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-pop",
    :url => 'http://www.reddit.com/.json',
    :topic_name => 'pop',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-tech",
    :url => 'http://www.reddit.com/r/technology.json',
    :topic_name => 'tech',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-science",
    :url => 'http://www.reddit.com/r/science.json',
    :topic_name => 'science',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-gaming",
    :url => 'http://www.reddit.com/r/gaming.json',
    :topic_name => 'games',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "r-food",
    :url => 'http://www.reddit.com/r/food.json',
    :topic_name => 'hobby',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  },
  { :name => "metafilter",
    :url => 'http://feeds.feedburner.com/Metafilter',
    :topic_name => 'news',
    :harvest_strategy => "rss" ,
    :type => "mefi"
  },
  { :name => "fark",
    :url => 'http://www.fark.com/fark.rss'
    :topic_name => 'news',
    :harvest_strategy => "rss",
    :type => "fark"
  },
  { :name => "r-funny",
    :url => 'http://www.reddit.com/r/funny.json',
    :topic_name => 'funny',
    :harvest_strategy => "reddit" ,
    :type => "reddit"
  }
].each do |source|
  unless Feed.where(["name = ?", source[:name]]).first
    feed = Feed.create(:name => source[:name],
                :harvest_strategy => source[:harvest_strategy],
                :type => source[:type],
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
