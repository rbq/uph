class UphEvent
  def initialize(entry)
    he  = HTMLEntities.new
    if entry.title.sub(/-\?{1,3}/, '').match \
      /(\d{1,2}\:\d{1,2})(-(\d{1,2}\:\d{1,2}))? (Raum ([a-zA-Z0-9]+)\: )?(.*)/
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
  def short_title;  @short_title ||= sanitize_title(@title); end
  def desc;  @desc; end
  def start; @start || ''; end
  def end;   @end;   end
  def room;  @room;  end
  def link;  @link;  end
  
  private
  
  def sanitize_title(t)
    t.sub!(/ \(.*/, '')
    t.sub!(/ \/ .*/, '')
    t.sub!(/[`´]s/, '\'s')
    #t.sub!(/ & .*/, '')
    t.sub!(/Probe - /, 'Probe: ')
    t.sub!(/^Offene[rs] /, '')
    t.sub!(/^Öffentliche[rs] /, '')
    t.sub!(/(Öffentliche )?Bandprobe - /, 'Probe: ')
    t.sub!(/(Offener )?Vortrag - /, 'Vortrag: ')
    
    case t
    when /Absolut Brunch/; 'Absolut Brunch'
    when /Alles was fliegt/; 'Alles was fliegt'
    when /Alles was schwimmt/; 'Alles was schwimmt'
    when /Butcherboy/; 'Butcherboy'
    when /CMS-Talk/; 'CMS-Talk'
    when /Datenschutz und Privatsphäre/; 'Datenschutz, Privatsphäre'
    when /Drupal Usergroup/; 'Drupal Usergroup'
    when /Drupaletics/; 'Drupaletics'
    when /Encouraging Training/; 'Encouraging Training'
    when /English Speaking Corner/; 'English Speaking Corner'
    when /e-stylez/; 'e-stylez'
    when /FMA \/ Kali/; 'FMA / Kali'
    when /Führung durch das Unperfekthaus/; 'Hausführung'
    when /Fortbildung Spielpädagogik/; 'Fortbildung Spielpädagogik'
    when /Fotostammtisch/; 'Fotostammtisch'
    when /Freie Religion/; 'Freie Religion'
    when /Geschl. Seminar/; 'Geschlossenes Seminar'
    when /Geschlossene Feier/; 'Geschlossene Feier'
    when /Geschlossene Gess?ellschaft/; 'Geschlossene Gesellschaft'
    when /Grosses Dinner-Buffet/; 'Großes Dinner-Buffet'
    when /Jeet Kune Do/; 'Jeet Kune Do'
    when /Joomla User Group/; 'Joomla User Group'
    when /Kalifornische Massage/; 'Kalifornische Massage'
    when /Kuvertieraktion/; 'Kuvertieraktion'
    when /Kultur der Technik/; 'Kultur der Technik'
    when /Latin-Footwork/; 'Latin-Footwork'
    when /LIEDERMACHER-PROBE/; 'Probe: Liedermacher'
    when /Linuxabend/; 'Linuxabend'
    when /Lotuscafe/; 'Lotuscafe'
    when /Malerei auf dem Weg zur Perfektion/; 'Malerei'
    when /Malerei nach Musik/; 'Malerei nach Musik'
    when /Margarita-Tag/; 'Margarita-Tag'
    when /Massage und integrative Körperarbeit/; 'Massage'
    when /Massagestunde/; 'Massagestunde'
    when /Matthias Scheidig Design/; 'Matthias Scheidig Design'
    when /Meridian-Yoga/; 'Meridian-Yoga'
    when /Möestyle/; 'Airbrush Möestyle'
    when /My body is my home/; 'My body is my home'
    when /Physik und Elektroniklabor/; 'Physik-/Elektroniklabor'
    when /Piratenpartei Deutschland/; 'Piratenpartei Deutschland'
    when /Pocket-PC-Club Ruhr/; 'Pocket-PC-Club Ruhr'
    when /Probe: unplugged Rock Pop-Music/; 'Probe: unplugged Rock Pop'
    when /Projektentwicklung und Beratung/; 'Projektentwicklung'
    when /Rüegg Drum.*Cool/; 'Rüegg Drum\'s Cool'
    when /Salsa, Bachata und Merengue/; 'Salsa, Bachata, Merengue'
    when /Salsakurse/; 'Salsakurse'
    when /Scottys Modellecke/; 'Scottys Modellecke'
    when /Schreib- und Spielwerkstatt/; 'Schreib- und Spielwerkstatt'
    when /Schreib- & Spielwerkstatt/; 'Schreib- und Spielwerkstatt'
    when /Sinfonia/; 'Sinfonia'
    when /Stammtisch.*sneep.info/; 'Stammtisch sneep.info'
    when /Ruhrstadtmaler/; 'Der Ruhrstadtmaler'
    when /Webworker Stammtisch/; 'Webworker-Stammtisch'
    else t
    end
  end
end