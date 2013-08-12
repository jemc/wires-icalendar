require 'wires'
require 'icalendar'

require 'pp'

module Wires
  
  class CalendarEvent < Event
    
    attr_accessor :summary
    attr_accessor :start_time
    attr_accessor :end_time
    
    def self.new_pair(ical_e)
      kwargs = ical_e.properties.dup
      
      keep_properties = \
        [:summary, :dtstart, :dtend]
        
      rename_properties = {
        :dtstart => :start_time,
        :dtend   => :end_time,
      }
      
      # Convert each key value from string to symbol
      kwargs.keys.each do |k| 
        kwargs[k.to_sym] = kwargs[k]
        kwargs.delete k
      end
      
      # Discard properties not in predetermined list
      kwargs.select! do |k,v|
        keep_properties.include? k
      end
      
      # Rename the specified properties from predetermined hash
      rename_properties.each_pair do |k1,k2| 
        kwargs[k2] = kwargs[k1]
        kwargs.delete k1
      end
      
      start_kwargs = kwargs.dup
      end_kwargs   = kwargs.dup
      
      [CalendarStartEvent.new(**start_kwargs),
       CalendarEndEvent.new(**end_kwargs),]
    end
  end
  
  class CalendarStartEvent < CalendarEvent
    alias_method :time,  :start_time
    alias_method :time=, :start_time=
  end
  
  class CalendarEndEvent < CalendarEvent
    alias_method :time,  :end_time
    alias_method :time=, :end_time=
  end
  
  class Calendar
    
    def initialize(file, index=0)
      file = File.open(file) unless file.is_a? File
      @calendar = (Icalendar.parse file)[index]
      
      @items = []
      @calendar.events.each do |ical_e|
        CalendarEvent.new_pair(ical_e).each do |e|
          @items << TimeSchedulerItem.new(e.time.to_time, e, Calendar)
        end
      end
    end
    
  end
end