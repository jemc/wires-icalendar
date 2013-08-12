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
    
  end
  
end

describe Wires::CalendarEvent do
  
  describe ".new" do
    
    it "is created from an Icalendar::Event"
    
  end
  
end