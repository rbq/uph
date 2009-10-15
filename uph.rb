#!/usr/bin/env ruby
%w'rubygems sinatra haml simple-rss open-uri icalendar date htmlentities'.each { |l| require l }

get '/', :agent => /AppleWebKit.*Mobile/ do
  redirect '/iphone'
end

get '/' do
  content_type 'text/html', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  haml :index
end


get '/ical' do
  content_type 'text/calendar', :charset => 'utf-8'
  response.headers['Content-Disposition'] = 'attachment;filename=UpH.ics'
  response.headers['Cache-Control'] = 'public, max-age=300'
  
  rss = fetch_rss
  cal = Icalendar::Calendar.new
  he  = HTMLEntities.new
  t   = Date.today

  rss.entries.each do |entry|
    if entry.title.match /(\d{1,2})\:(\d{1,2})-(\d{1,2})\:(\d{1,2}) (.*)/
      cal.event do
        uid     entry.guid
        dtstart DateTime.civil(t.year, t.month, t.day, $1.to_i, $2.to_i)
        dtend   DateTime.civil(t.year, t.month, t.day, $3.to_i, $4.to_i)
        summary he.decode($5)
        #description ''
        url     entry.link
      end
    end
  end

  cal.to_ical
end


get '/iphone' do
  content_type 'text/html', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  @entries = parse_rss(fetch_rss.entries)
  haml :index_iphone, :layout => :layout_iphone
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
  'Fehler: ' + env['sinatra.error'].name
end


helpers do
  def fetch_rss
    rss = SimpleRSS.parse open('http://www.unperfekthaus.de/feed/rss.xml')
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
          :url     => entry.link
        }
      else
        {
          :title   => entry.title
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