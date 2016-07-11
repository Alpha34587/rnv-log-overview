Gem::Specification.new do |s|
  s.name        = 'xlo'
  s.version     = '0.0.1.3'
  s.date        = '2016-06-22'
  s.summary     = "Xml Log Overview"
  s.description = "An aggregator of xml log for rnv and xmllint error"
  s.authors     = ["Simon Meoni"]
  s.email       = 'simonmeoni@aol.com'
  s.files       = ["lib/xlo.rb"]
  s.requirements << 'rnv, xmllint'
  s.extra_rdoc_files = ['README.md']
  s.executables << 'xlo'
  s.homepage    =
    'http://rubygems.org/gems/xlo'
    'https://github.com/Alpha34587/xlo'
  s.license       = 'GPL-3.0'
end
