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
    t.sub!(/[`´]s/, '\'s')
    t.sub!(/Probe - /, 'Probe: ')
    
    case t
    when /Alles was fliegt/; 'Alles was fliegt'
    when /Butcherboy/; 'Butcherboy'
    when /CMS-Talk/; 'CMS-Talk'
    when /Drupaletics/; 'Drupaletics'
    when /FMA \/ Kali/; 'FMA / Kali'
    when /Freie Religion/; 'Freie Religion'
    when /Geschlossene Feier/; 'Geschlossene Feier'
    when /Geschlossene Gess?ellschaft/; 'Geschlossene Gesellschaft'
    when /Grosses Dinner-Buffet/; 'Grosses Dinner-Buffet'
    when /e-stylez/; 'e-stylez'
    when /Jeet Kune Do/; 'Jeet Kune Do'
    when /LIEDERMACHER-PROBE/; 'Probe: Liedermacher'
    when /Linuxabend/; 'Linuxabend'
    when /Lotuscafe/; 'Lotuscafe'
    when /Matthias Scheidig Design/; 'Matthias Scheidig Design'
    when /Physik und Elektroniklabor/; 'Physik-/Elektroniklabor'
    when /Probe: unplugged Rock Pop-Music/; 'Probe: unplugged Rock Pop'
    when /Scottys Modellecke/; 'Scottys Modellecke'
    when /Sinfonia/; 'Sinfonia'
    when /Möestyle/; 'Airbrush Möestyle'
    when /Ruhrstadtmaler/; 'Der Ruhrstadtmaler'
    else t
    end
  end
end