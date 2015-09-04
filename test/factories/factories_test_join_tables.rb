
Factory.define :genrestree do |t|
  t.child_id 1
  t.parent_id 2
end

Factory.define :aconnector do |a|
  a.ltitles_id 1
  a.lactors_id 2
end

Factory.define :dconnector do |d|
  d.ltitles_id 1
  d.ldirectors_id 2
end

Factory.define :gconnector do |g|
  g.ltitles_id 1
  g.lgenres_id 2
end

Factory.define :fconnector do |f|
  f.ltitles_id 1
  f.lformats_id 2
  f.availability_int 1239087600
  f.availability "2009-04-07 15:00:00"
end