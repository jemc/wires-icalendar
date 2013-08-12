$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))
require 'wires/icalendar'

require 'wires/test'
begin require 'jemc/reporter'; rescue LoadError; end


$test_cal_path = File.expand_path('./fixtures/life.ics', File.dirname(__FILE__))
$test_cal = Icalendar::Calendar.new.tap do |cal|
  cal.event do
    dtstart     Date.new(2005, 04, 29)
    dtend       Date.new(2005, 04, 28)
    summary     "Summary."
    description "Description..."
  end
end

describe Wires::Calendar do
  
  describe ".new" do
    it "can create by parsing from a filepath" do
      cal = Wires::Calendar.new $test_cal_path
      cal.must_be_instance_of Wires::Calendar
    end
    
    it "can create by parsing a File object" do
      cal = Wires::Calendar.new File.open($test_cal_path)
      cal.must_be_instance_of Wires::Calendar
    end
    
    it "can create directly from an Icalendar::Calendar object" do
      cal = Wires::Calendar.new $test_cal
      cal.must_be_instance_of Wires::Calendar
    end
  end
  
end

describe Wires::CalendarEvent do
  
  describe ".new_pair" do
    
    it "creates a CalendarStartEvent and CalendarEndEvent"\
       " from an Icalendar::Event" do
      ical = Icalendar.parse(File.open $test_cal_path)
      pair = Wires::CalendarEvent.new_pair(ical[0].events[0])
      pair[0].must_be_instance_of Wires::CalendarStartEvent
      pair[1].must_be_instance_of Wires::CalendarEndEvent
    end
    
    it "returns only a CalendarStartEvent in the array"\
       " if the Icalendar::Event has no dtend" do
      pair = Wires::CalendarEvent.new_pair(
        Icalendar::Event.new.tap do |e|
          e.dtstart     Date.new(2005, 04, 29)
          e.summary     "Summary."
          e.description "Description..."
        end
      )
      pair[0].must_be_instance_of Wires::CalendarStartEvent
      pair.size.must_equal 1
    end
  end
  
end