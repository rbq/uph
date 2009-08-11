%w'rubygems sinatra simple-rss open-uri icalendar date htmlentities'.each { |l| require l }

get '/ical' do
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

get '/*' do
  redirect '/ical'
end

error do
  'Fehler: ' + env['sinatra.error'].name
end