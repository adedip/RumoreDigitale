class FeedEntry < ActiveRecord::Base
    def self.update_from_feed(feed_url,t)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries,t)
    end

    def self.update_from_feed_continuously(feed_url, delay_interval = 5.minutes, t)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries,t)
      loop do
        sleep delay_interval
        feed = Feedzirra::Feed.update(feed)
        add_entries(feed.new_entries,t) if feed.updated?
      end
    end
    
    def self.update_from_last_feed(feed_url)
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      add_entries(feed.entries)
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end

    private

    def self.add_entries(entries, t)
      if t == 1
        entries.each do |entry|
          unless exists? :guid => entry.id
            create!(
              :name         => entry.title.sub(/ il /,": "),
              :summary      => entry.summary.gsub(/"\/wp-content/, '"http://www.rumoredigitale.com/wp-content').gsub(/href="\//, 'href="http://www.rumoredigitale.com/'),
              :url          => entry.url,
              :published_at => entry.published - 2.hours,
              :guid         => entry.id,
              :feed_type    => t
            )
          end
        end
      else
        entries.each do |entry|
          unless exists? :guid => entry.id
            create!(
              :name         => entry.title,
              :summary      => entry.content,
              :url          => entry.url,
              :published_at => entry.published - 2.hours,
              :guid         => entry.id,
              :feed_type    => t
            )
          end
        end
      end
    end
end
