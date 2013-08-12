require 'wires'
require 'icalendar'

require 'pp'

module Wires
  
  class CalendarEvent < Event
    
    def self.rename_properties; {
      :dtstart => :start_time,
      :dtend   => :end_time,
    }; end
    
    def self.additional_properties
      [:summary, :description]
    end
    
    def self.properties
      (additional_properties+rename_properties.values).uniq
    end
    
    attr_accessor *properties
    
    def self.new_pair(ical_e)
      kwargs = ical_e.properties.dup
      
      # Convert each key value from string to symbol
      kwargs.keys.each do |k| 
        kwargs[k.to_sym] = kwargs[k]
        kwargs.delete k
      end
      
      # Rename the specified properties from predetermined hash
      self.rename_properties.each_pair do |k1,k2| 
        kwargs[k2] = kwargs[k1]
        kwargs.delete k1
      end
      
      # Discard properties not in predetermined list
      kwargs.select! do |k,v|
        self.properties.include? k
      end
      
      start_kwargs = kwargs.dup
      end_kwargs   = kwargs.dup
      
      if kwargs[:end_time]
        [CalendarStartEvent.new(**start_kwargs),
         CalendarEndEvent.new(**end_kwargs)]
      else
        [CalendarStartEvent.new(**start_kwargs)]
      end
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
    
    attr_accessor :items
    
    def initialize(cal, index=0)
      case cal
      when Icalendar::Calendar
        @calendar = cal
      when File
        @calendar = (Icalendar.parse cal)[index]
      else
        @calendar = (Icalendar.parse File.open(cal))[index]
      end
      
      @items = []
      @calendar.events.each do |ical_e|
        CalendarEvent.new_pair(ical_e).each do |e|
          @items << TimeSchedulerItem.new(e.time.to_time, e, Calendar)
        end
      end
    end
    
  end
end