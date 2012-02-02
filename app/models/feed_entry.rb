class FeedEntry < ActiveRecord::Base
  def self.update_from_feed(feed_url)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries)
    end

    def self.update_from_feed_continuously(feed_url, delay_interval = 5.minutes)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries)
      loop do
        sleep delay_interval
        feed = Feedzirra::Feed.update(feed)
        add_entries(feed.new_entries) if feed.updated?
      end
    end
    
    def self.update_from_last_feed(feed_url)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries)
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end

    private

    def self.add_entries(entries)
      entries.each do |entry|
        unless exists? :guid => entry.id
          create!(
            :name         => entry.title.sub(/ il /,": "),
            :summary      => entry.summary.gsub(/<img src="/, '<img src="http://www.rumoredigitale.com')  ,
            :url          => entry.url,
            :published_at => entry.published - 1.hours,
            :guid         => entry.id
          )
        end
      end
    end
end
