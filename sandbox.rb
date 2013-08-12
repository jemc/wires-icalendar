require 'wires'
require 'icalendar'

Icalendar.constants
         # .map{|x| Icalendar.const_get(x)}
         # .each{|x| p [x, x.class]}

p File.open('./spec/fixtures/life.ics')