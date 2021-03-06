class UphEvent
  def initialize(entry)
    he  = HTMLEntities.new
    if entry.title.sub(/-\?{1,3}/, '').match \
      /(\d{1,2}\:\d{1,2})(-(\d{1,2}\:\d{1,2}))? ([Rr]aum\s*([a-zA-Z0-9]+)\: )?(.*)/
      @guid  = entry.guid
      @start = $1
      @end   = $3
      @room  = $5
      @title = he.decode($6)
      @link  = entry.link
    else
      @guid  = entry.guid
      @title = he.decode(entry.title)
    end
  end

  def guid;  @guid;  end
  def title; @title; end
  def short_title;  @short_title ||= UphEvent.sanitize_title(@title); end
  def desc;  @desc; end
  def start; @start || ''; end
  def end;   @end;   end
  def room;  @room;  end
  def link;  @link;  end

  def all_day?
    @start == Uph::OPEN_FROM && @end == Uph::OPEN_TO
  end

  def self.sanitize_title(t)
    t.sub!(/ \(.*/, '')
    t.sub!(/ \/ .*/, '')
    t.sub!(/[`´]s/, '\'s')
    #t.sub!(/ & .*/, '')
    t.sub!(/Probe - /, 'Probe: ')
    t.sub!(/^Offene[rs] /, '')
    t.sub!(/^Öffentliche[rs] /, '')
    t.sub!(/(Öffentliche )?Bandprobe - /, 'Probe: ')
    t.sub!(/(Offener )?Vortrag - /, 'Vortrag: ')
    t.sub!(/Konzert von /, 'Konzert: ')

    case t
    when /Absolut Brunch/; 'Absolut Brunch'
    when /Alles was fliegt/; 'Alles was fliegt'
    when /Alles was schwimmt/; 'Alles was schwimmt'
    when /Arbeitskreis(es)? Drogenpolitik/; 'Arbeitskreis Drogenpolitik'
    when /Butcherboy/; 'Butcherboy'
    when /CMS-Talk/; 'CMS-Talk'
    when /Datenschutz und Privatsphäre/; 'Datenschutz, Privatsphäre'
    when /Drupal Usergroup/; 'Drupal Usergroup'
    when /Drupaletics/; 'Drupaletics'
    when /Encaustic-Wachskunst/; 'Encaustic-Wachskunst'
    when /Encouraging Training/; 'Encouraging Training'
    when /English Speaking Corner/; 'English Speaking Corner'
    when /e-stylez/; 'e-stylez'
    when /FMA \/ Kali/; 'FMA / Kali'
    when /Führung durch das Unperfekthaus/; 'Hausführung'
    when /Flammenwerk/; 'Flammenwerk'
    when /Fortbildung Spielpädagogik/; 'Fortbildung Spielpädagogik'
    when /Fotostammtisch/; 'Fotostammtisch'
    when /Fotografenstammtisch/; 'Fotografenstammtisch'
    when /Fotokurs Das/; 'Fotokurs'
    when /Freie Religion/; 'Freie Religion'
    when /Geschl. Seminar/; 'Geschlossenes Seminar'
    when /Geschlossene Feier/; 'Geschlossene Feier'
    when /Geschlossene Gess?ellschaft/; 'Geschlossene Gesellschaft'
    when /Grosses Dinner-Buffet/; 'Großes Dinner-Buffet'
    when /Habari Usergroup/; 'Habari-Usergroup'
    when /HUT - DESIGN/; 'Hut-Design'
    when /Intuitive Objektgestaltung/; 'Intuitive Objektgestaltung'
    when /Jeet Kune Do/; 'Jeet Kune Do'
    when /Joomla User Group/; 'Joomla User Group'
    when /Kalifornische Massage/; 'Kalifornische Massage'
    when /Kuvertieraktion/; 'Kuvertieraktion'
    when /Kultur der Technik/; 'Kultur der Technik'
    when /Lach - Yoga/; 'Lach-Yoga'
    when /Latin-Footwork/; 'Latin-Footwork'
    when /Lebensrettende Sofortmaßnahmen/; 'Lebensrettende Sofortmaßn.'
    when /LIEDERMACHER-PROBE/; 'Probe: Liedermacher'
    when /Linuxabend/; 'Linuxabend'
    when /Lotuscafe/; 'Lotuscafe'
    when /Lunch & Dinner-Buffet/; 'Lunch-/Dinner-Buffet'
    when /Malerei auf dem Weg zur Perfektion/; 'Malerei'
    when /Malerei nach Musik/; 'Malerei nach Musik'
    when /Margarita-Tag/; 'Margarita-Tag'
    when /Maschenphantasien/; 'Maschenphantasien'
    when /Massage und integrative Körperarbeit/; 'Massage'
    when /Massagestunde/; 'Massagestunde'
    when /Matthias Scheidig Design/; 'Matthias Scheidig Design'
    when /Meridian-Yoga/; 'Meridian-Yoga'
    when /Möestyle/; 'Airbrush Möestyle'
    when /My body is my home/; 'My body is my home'
    when /NRW-Ukulelenspieler/; 'NRW-Ukulelenspieler'
    when /Physik und Elektroniklabor/; 'Physik-/Elektroniklabor'
    when /Piratenpartei Deutschland/; 'Piratenpartei Deutschland'
    when /Pocket-PC-Club Ruhr/; 'Pocket-PC-Club Ruhr'
    when /Portraitfotografie/; 'Portraitfotografie'
    when /Probe: unplugged Rock Pop-Music/; 'Probe: unplugged Rock Pop'
    when /Projektentwicklung und Beratung/; 'Projektentwicklung'
    when /QADRATOLOGO/; 'QADRATOLOGO'
    when /Rüegg Drum.*Cool/; 'Rüegg Drum\'s Cool'
    when /Ruhrstadtmaler/; 'Der Ruhrstadtmaler'
    when /Salsa, Bachata und Merengue/; 'Salsa, Bachata, Merengue'
    when /Salsakurse/; 'Salsakurse'
    when /Scottys Modellecke/; 'Scottys Modellecke'
    when /Schreib- und Spielwerkstatt/; 'Schreib- und Spielwerkstatt'
    when /Schreib- & Spielwerkstatt/; 'Schreib- und Spielwerkstatt'
    when /Sinfonia/; 'Sinfonia'
    when /Stammtisch.*sneep.info/; 'Stammtisch sneep.info'
    when /Teams OS\/2 Ruhr e.V./; 'Team OS/2 Ruhr e. V.'
    when /Unperfekthaus.+heute geschlossen/; 'heute geschlossen'
    when /Webworker Stammtisch/; 'Webworker-Stammtisch'
    when /WG-Hotel.*ausgebucht/; 'WG-Hotel ausgebucht'
    else t
    end
  end
end