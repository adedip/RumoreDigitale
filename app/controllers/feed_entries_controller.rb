class FeedEntriesController < ApplicationController
  
  before_filter :find_feedEntry, :only => [:show, :edit, :update, :destroy]
  before_filter :update_feeds, :only => [:index]
  before_filter :update_blog_feeds, :only => [:index]

  # GET /feedEntries
  # GET /feedEntries.xml
  def index
    @feedEntries = FeedEntry.where("feed_type=1").limit(20).order("published_at DESC")
    @blogEntries = FeedEntry.where("feed_type=2").limit(20).order("published_at DESC")
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @feedEntries }
    end
  end

  # GET /feedEntries/1
  # GET /feedEntries/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @feedEntrie }
    end
  end

  # GET /feedEntries/new
  # GET /feedEntries/new.xml
  def new
    @feedEntrie = FeedEntrie.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @feedEntrie }
    end
  end

  # GET /feedEntries/1/edit
  def edit
  end

  # POST /feedEntries
  # POST /feedEntries.xml
  def create
    @feedEntrie = FeedEntrie.new(params[:feedEntrie])

    respond_to do |wants|
      if @feedEntrie.save
        flash[:notice] = 'FeedEntrie was successfully created.'
        wants.html { redirect_to(@feedEntrie) }
        wants.xml  { render :xml => @feedEntrie, :status => :created, :location => @feedEntrie }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @feedEntrie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feedEntries/1
  # PUT /feedEntries/1.xml
  def update
    respond_to do |wants|
      if @feedEntrie.update_attributes(params[:feedEntrie])
        flash[:notice] = 'FeedEntrie was successfully updated.'
        wants.html { redirect_to(@feedEntrie) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @feedEntrie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feedEntries/1
  # DELETE /feedEntries/1.xml
  def destroy
    @feedEntrie.destroy

    respond_to do |wants|
      wants.html { redirect_to(feedEntries_url) }
      wants.xml  { head :ok }
    end
  end
  
  def force_update
    FeedEntry.update_from_feed("http://www.rumoredigitale.com/forum/?xfeed=all",1)
    respond_to do |wants|
      wants.html {redirect_to(root_path)}
    end
  end

  private
    def update_feeds
      last = FeedEntry.where("feed_type = 1").last
      if last.created_at < 5.minutes.ago
        if last.updated_at < 1.minutes.ago
          last.updated_at = Time.now
          last.save
          FeedEntry.update_from_feed("http://www.rumoredigitale.com/forum/?xfeed=all",1)
        end
      end
    end
    
    def update_blog_feeds
      last = FeedEntry.where("feed_type = 2").last
      if last.created_at < 1440.minutes.ago
        if last.updated_at < 500.minutes.ago
          last.updated_at = Time.now
          last.save
          FeedEntry.update_from_feed("http://www.rumoredigitale.com/feed",2)
        end
      end
    end
    
    def find_feedEntry      
        @feedEntry = FeedEntry.find(params[:id])
    end

end
