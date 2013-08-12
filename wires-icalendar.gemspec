Gem::Specification.new do |s|
  s.name          = 'wires-icalendar'
  s.version       = '0.0.0'
  s.date          = '2013-07-18'
  s.summary       = "wires-icalendar"
  s.description   = "Wires extension gem for integration with icalendar events."
  s.authors       = ["Joe McIlvain"]
  s.email         = 'joe.eli.mac@gmail.com'
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/jemc/wires-icalendar/'
  s.licenses      = "Copyright (c) Joe McIlvain. All rights reserved "
  
  s.add_dependency('wires')
  s.add_dependency('icalendar', '~> 1.4.1')
  
  s.add_development_dependency('rake')
  s.add_development_dependency('wires-test')
  s.add_development_dependency('jemc-reporter')
  s.add_development_dependency('timecop')
end