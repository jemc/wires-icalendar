require 'wires'
require 'icalendar'

require 'pp'

module Wires
  
  class CalendarEvent < Event
    def initialize(ical_e)
      # pp ical_e.properties
    end
  end
  
  class Calendar
    def initialize(file)
      file = File.open(file) unless file.is_a? File
      @calendars = Icalendar.parse file
      
      @items = @calendars[0].events.map do |ical_e|
        event = CalendarEvent.new(ical_e)
        TimeSchedulerItem.new(Time.now, event, Calendar)
      end
    end
  end
end