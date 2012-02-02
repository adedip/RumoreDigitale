class FeedEntriesController < ApplicationController
  before_filter :find_feedEntry, :only => [:show, :edit, :update, :destroy]
  before_filter :update_feeds, :only => [:index]

  # GET /feedEntries
  # GET /feedEntries.xml
  def index
    @feedEntries = FeedEntry.all

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

  private
    def update_feeds
      FeedEntry.update_from_feed("http://www.rumoredigitale.com/forum/?xfeed=all&feedkey=551cc066-3491-4196-a857-7ae86fc7e5ea")
    end
    
    def find_feedEntry
      @feedEntry = FeedEntry.find(params[:id])
    end

end
