require 'open-uri'
require 'nokogiri'
require 'json'

namespace :import do

  desc 'import a reddit json feed pass source name with NAME=source'
  task :reddit => :environment do
    Feed.where(["harvest_strategy = ?", "reddit"]).all.each do |source|
      begin
        doc = open(source.url).read
        json = JSON.parse(doc)
        json["data"]["children"].each do |item|
          item = item["data"]
          unless Listing.where(["feed_id = ? AND url = ?", source.id, item["url"]]).first
            listing = Listing.create(:feed => source,
                                     :url => item["url"],
                                     :comments_url => "http://reddit.com#{item['permalink']}",
                                     :feed_type => source.feed_type,
                                     :title => item["title"])

            RedditListing.create(:listing => listing,
                                 :nsfw => item["over18"] || false,
                                 :self => item["is_self"] || false,
                                 :author => item["author"] || false,
                                 :num_comments => item["num_comments"],
                                 :ups => item["ups"],
                                 :downs => item["downs"],
                                 :subreddit => item["subreddit"],
                                 :selftext => item["selftext"])
          end
        end
      rescue Exception
      end
      sleep(1)
    end
  end

  desc 'import hacker news'
  task :hn => :environment do 
    doc = Nokogiri::XML(open("http://news.ycombinator.com/rss"))
    source = Feed.where(["name = ?", "Hacker News"]).first
    listings = doc.css('item')
    listings.each do |item|
      unless Listing.where(["feed_id = ? AND url = ?", source.id, item.css('link').first.content]).first
        listing = Listing.create(:feed => source,
                                 :feed_type => source.feed_type,
                                 :title => item.css('title').first.content,
                                 :url => item.css('link').first.content,
                                 :comments_url => item.css('comments').first.content)
      end
    end
  end

  desc 'import rss'
  task :rss => :environment do 
    Feed.where(["harvest_strategy = ?", "rss"]).all.each do |source|
      doc = Nokogiri::XML(open(source.url))
      listings = doc.css('item')
      listings.each do |item|
        unless Listing.where(["feed_id = ? AND url = ?", source.id, item.css('link').first.content]).first
          listing = Listing.create(:feed => source,
                                   :feed_type => source.feed_type,
                                   :title => item.css('title').first.content,
                                   :url => item.css('link').first.content)
        end
      end
    end
  end

  desc 'collate into links'
  task :collate => :environment do 
    Listing.where("link_id IS NULL").each do |listing|
      if existing_link = Link.where(["url = ?", listing.url]).first
        listing.link_id = existing_link.id
        listing.save
      else
        link = Link.create(:title => listing.title,
                           :url => listing.url)
        link.topic_id = listing.feed.topic_id
        link.save
        listing.link = link
        listing.save
      end
    end
  end

  desc 'add_wiki_leaks'
  task :add_wikileaks => :environment do
    Topic.create(:name => "wikileaks")
    [
      { :name => "r-wikileaks",
        :url => 'http://www.reddit.com/r/wikileaks.json',
        :topic_name => 'wikileaks',
        :harvest_strategy => "reddit" ,
        :type => "reddit"
    },
      { :name => "erictric",
        :url => 'http://feeds.feedburner.com/Erictric?format=xml',
        :topic_name => 'wikileaks',
        :harvest_strategy => "rss" ,
        :type => "other"
    },
      { :name => "techeye",
        :url => 'http://www.techeye.net/company/wikileaks/feed',
        :topic_name => 'wikileaks',
        :harvest_strategy => "rss" ,
        :type => "other"
    }].each do |source|
      unless Feed.where(["name = ?", source[:name]]).first
        feed = Feed.create(:name => source[:name],
                           :harvest_strategy => source[:harvest_strategy],
                           :feed_type => source[:type],
                           :url => source[:url])
        topic = Topic.where("name = ?", source[:topic_name]).first
        feed.topic = topic
        feed.save
      end
    end

  end

end
