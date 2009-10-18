#!/usr/bin/env ruby
%w'rubygems backports/1.8.7 sinatra haml sass simple-rss open-uri date htmlentities'.each { |l| require l }

get '/', :agent => /AppleWebKit.*Mobile/ do
  redirect '/iphone'
end


get '/' do
  content_type 'text/html', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  haml :'screen/index', :layout => :'screen/layout'
end


get '/ical' do
  redirect 'http://www.unperfekthaus.de/feed/ics', 301
end


get '/iphone' do
  content_type 'text/html', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  @entries = parse_rss(fetch_rss.entries)
  @entries_grouped = @entries.group_by{ |e| e[:start] }.sort
  haml :'iphone/index', :layout => :'iphone/layout'
end


get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  sass :"stylesheets/#{params[:name]}"
end


not_found do
  redirect '/'
end


error do
  'Fehler: ' + env['sinatra.error'].message
end


helpers do
  def fetch_rss
    SimpleRSS.parse open('http://www.unperfekthaus.de/feed/rss.xml')
  end
  
  def parse_rss(entries)
    he  = HTMLEntities.new
    entries.map do |entry|
      if entry.title.match /(\d{1,2}\:\d{1,2})(-(\d{1,2}\:\d{1,2}))? (Raum ([A-Z0-9]+)\: )?(.*)/
        {
          :id      => entry.guid,
          :start   => $1,
          :end     => $3,
          :room    => $5,
          :title   => he.decode($6),
          :description => nil,
          :link    => entry.link
        }
      else
        {
          :id      => entry.guid,
          :start   => nil,
          :end     => nil,
          :room    => nil,
          :title   => he.decode(entry.title),
          :description => nil,
          :link    => nil
        }
      end
    end
  end

  class String
    def word_shorten(length = 50)
      if self.length >= length 
        short = self[0, length-2].split(/\s/)
        short[0, short.length-1].join(' ') + ' …'
      else 
        self
      end
    end
  end
end