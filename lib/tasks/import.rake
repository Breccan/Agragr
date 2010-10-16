require 'open-uri'
require 'nokogiri'
require 'json'

namespace :import do

  desc 'import a reddit json feed pass source name with NAME=source'
  task :reddit => :environment do
    if source = Feed.where(["name = ?", ENV['NAME']]).first
      doc = open(source.url).read
      json = JSON.parse(doc)
      json["data"]["children"].each do |item|
        item = item["data"]
        unless Listing.where(["feed_id = ? AND url = ?", source.id, item["url"]]).first
          listing = Listing.create(:feed => source,
                                   :url => item["url"],
                                   :title => item["title"])

          RedditListing.create(:listing => listing,
                                :nsfw => item["over18"] == "true" ? true : false,
                                :self => item["is_self"] == "true" ? true : false,
                                :author => item["author"],
                                :num_comments => item["num_comments"],
                                :ups => item["ups"],
                                :downs => item["downs"],
                                :subreddit => item["subreddit"],
                                :selftext => item["selftext"])
        end
      end
    else
      puts "source not found"
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
                                 :title => item.css('title').first.content,
                                 :url => item.css('link').first.content,
                                 :comments_url => item.css('comments').first.content)
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
        listing.link = link
        listing.save
      end
    end
  end

end
