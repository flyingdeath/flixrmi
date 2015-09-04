
Factory.define :ltitle do |t|
  t.release_year 1997
  t.title "La Femme Nikita"
  t.netflixLink "http://www.netflix.com/Movie/La_Femme_Nikita_Season_1/60030843"
  t.ext_id "http://api-public.netflix.com/catalog/titles/series/60030843"
  t.updated 1268367696
end

Factory.define :lupc do |u|
  u.number 1239087600
end


Factory.define :lgenre do |g|
  g.name "20th Century Period Pieces"
end

Factory.define :lformat do |f|
  f.name "Blu-ray"
end

Factory.define :ldirector do |d|
  d.name "Steve Miner"
  d.ext_id "http://api-public.netflix.com/catalog/people/20000720"
end

Factory.define :lactor do |a|
  a.name "Anna Paquin"
  a.ext_id "http://api-public.netflix.com/catalog/people/20001977"
end


Factory.define :ltitle_full, :parent => :ltitle do |ltitle|
  ltitle.after_create { |t| 
                         t.lgenres    {|g| [g.association(:lgenre)]} 
                         t.lformats   {|f| [f.association(:lformat)]}
                         t.ldirectors {|d| [d.association(:ldirector)]}
                         t.lactors    {|a| [a.association(:lactor)]}
                         t.lupcs      {|u| [u.association(:lupc)]}
                      }
end

Factory.define :lgenre_full, :parent => :lgenre do |genre|
  genre.after_create { |g| g.ltitles {|ltitle| [ltitle.association(:ltitle)]} }
end

Factory.define :lupc_full, :parent => :lupc do |lupc|
  lupc.after_create { |u| u.ltitle {|ltitle| [ltitle.association(:ltitle)]} }
end

Factory.define :ldirector_full, :parent => :ldirector do |ldirector|
  ldirector.after_create { |d| d.ltitles {|ltitle| [ltitle.association(:ltitle)]} }
end

Factory.define :lformat_full, :parent => :lformat do |lformat|
  lformat.after_create { |f| f.ltitles {|ltitle| [ltitle.association(:ltitle)]} }
end

Factory.define :lactor_full, :parent => :lactor do |lactor|
  lactor.after_create { |a| a.ltitles {|ltitle| [ltitle.association(:ltitle)]} }
end




Factory.define :genrestree do |t|
  t.child_id 1
  t.parent_id 2
end

Factory.define :aconnector do |a|
   a.association :ltitle
   a.association :lactor
end

Factory.define :gconnector do |a|
   a.association :ltitle
   a.association :lgenre
end

Factory.define :dconnector do |a|
   a.association :ltitle
   a.association :ldirector
end

Factory.define :fconnector do |a|
   a.association :ltitle
   a.association :lformat
   a.availability_int 1239087600
   a.availability "2009-04-07 15:00:00"
end






