%w'rubygems sinatra haml simple-rss open-uri icalendar date htmlentities'.each { |l| require l }

get '/' do
  response.headers['Cache-Control'] = 'public, max-age=1800'
  content_type 'text/html', :charset => 'utf-8'
  haml :index
end

get '/ical' do
  response.headers['Cache-Control'] = 'public, max-age=300'
  content_type 'text/calendar', :charset => 'utf-8'
  
  rss = SimpleRSS.parse open('http://www.unperfekthaus.de/feed/rss.xml')
  he  = HTMLEntities.new
  cal = Icalendar::Calendar.new
  t   = Date.today

  rss.entries.each do |entry|
    if entry.title.match /(\d{1,2})\:(\d{1,2})-(\d{1,2})\:(\d{1,2}) (.*)/
      cal.event do
        dtstart DateTime.civil(t.year, t.month, t.day, $1.to_i, $2.to_i)
        dtend   DateTime.civil(t.year, t.month, t.day, $3.to_i, $4.to_i)
        summary he.decode($5)
        description entry.link
      end
    end
  end

  cal.to_ical
end

get '/stylesheets/:name.css' do
  response.headers['Cache-Control'] = 'public, max-age=1800'
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/#{params[:name]}"
end

get '/*' do
  redirect '/'
end

error do
  'Fehler: ' + env['sinatra.error'].name
end