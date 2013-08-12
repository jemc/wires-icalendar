$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))
require 'wires/icalendar'

require 'wires/test'
begin require 'jemc/reporter'; rescue LoadError; end


$testcal = File.expand_path('./fixtures/life.ics', File.dirname(__FILE__))

describe Wires::Calendar do
  
  describe ".new" do
    
    it "can create by parsing from a filepath" do
      cal = Wires::Calendar.new $testcal
      cal.must_be_instance_of Wires::Calendar
    end
    
    it "can create by parsing a File object" do
      cal = Wires::Calendar.new File.open($testcal)
      cal.must_be_instance_of Wires::Calendar
    end
    
    # it "can create from a specific calendar in an ics file"
    
  end
  
end

describe Wires::CalendarEvent do
  
  describe ".new_pair" do
    
    it "creates a CalendarStartEvent and CalendarEndEvent"\
       " from an Icalendar::Event" do
      ical = Icalendar.parse(File.open $testcal)
      pair = Wires::CalendarEvent.new_pair(ical[0].events[0])
      pair[0].must_be_instance_of Wires::CalendarStartEvent
      pair[1].must_be_instance_of Wires::CalendarEndEvent
    end
    
  end
  
end