#!/usr/bin/env ruby
%w'rubygems backports/1.8.7 sinatra haml sass simple-rss open-uri icalendar date htmlentities'.each { |l| require l }

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
  
  t   = Date.today
  cal = Icalendar::Calendar.new
  parse_rss(fetch_rss.entries).each do |entry|
    if entry[:start] && entry[:end]
      cal.event do
        uid     entry[:id]
        dtstart DateTime.civil(t.year, t.month, t.day, entry[:start][0..1].to_i, entry[:start][3..4].to_i)
        dtend   DateTime.civil(t.year, t.month, t.day, entry[:end][0..1].to_i, entry[:end][3..4].to_i)
        summary entry[:title]
        #description ''
        url     entry[:link]
      end
    end
  end
  cal.to_ical
end


get '/iphone' do
  content_type 'text/html', :charset => 'utf-8'
  response.headers['Cache-Control'] = 'public, max-age=1800'
  @entries = parse_rss(fetch_rss.entries)
  @entries_grouped = @entries.group_by{ |e| e[:start] }.sort
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
  'Fehler: ' + env['sinatra.error'].message
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