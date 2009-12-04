#!/usr/bin/env ruby
%w'rubygems backports/1.8.7 sinatra haml sass simple-rss open-uri date tzinfo htmlentities lib/uph lib/uph_event'.each { |l| require l }

get '/', :agent => /AppleWebKit.*Mobile/ do
  redirect '/iphone'
end

get '/' do
  redirect '/about'
end

get '/about' do
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
  all_day = @entries.group_by{ |e| e.all_day? }
  @entries_all_day = all_day[true]
  @entries_grouped = all_day[false].group_by{ |e| e.start }.sort
  @now = TZInfo::Timezone.get('Europe/Berlin').now.strftime('%H:%M')
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
    entries.map do |entry|
      UphEvent.new(entry)
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