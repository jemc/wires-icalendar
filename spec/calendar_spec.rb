$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))
require 'wires/icalendar'

require 'wires/test'
begin require 'jemc/reporter'; rescue LoadError; end

require 'timecop' # for time mocking functions


$test_cal_path = File.expand_path('./fixtures/life.ics', File.dirname(__FILE__))
$test_cal = Icalendar::Calendar.new.tap do |cal|
  cal.event do
    dtstart     1.year.from_now
    dtend       1.hour.since(1.year.from_now)
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
    
    it "can create directly from a block with Icalendar::Calendar syntax" do
      cal = Wires::Calendar.new do |c|
        c.event do
          dtstart     1.year.from_now
          dtend       1.hour.since(1.year.from_now)
          summary     "Summary."
          description "Description..."
        end
      end
      cal.must_be_instance_of Wires::Calendar
    end
    
    it "creates an empty Wires::Calendar when given no arguments" do
      cal = Wires::Calendar.new
      cal.must_be_instance_of Wires::Calendar
    end
    
    it "yields TimeSchedulerItems that are ready at the right time" do
      cal = Wires::Calendar.new do |cal|
        cal.event do
          dtstart     1.year.from_now
          dtend       1.hour.since(1.year.from_now)
          summary     "Summary."
          description "Description..."
        end
      end
      
      cal.items
         .select{|x| x.event.is_a? Wires::CalendarStartEvent}
         .each do |i|
        i.ready?.must_equal false
      end
      cal.items
         .select{|x| x.event.is_a? Wires::CalendarEndEvent}
         .each do |i|
        i.ready?.must_equal false
      end
      
      Timecop.travel 1.year.from_now
      
      cal.items
         .select{|x| x.event.is_a? Wires::CalendarStartEvent}
         .each do |i|
        i.ready?.must_equal true
      end
      cal.items
         .select{|x| x.event.is_a? Wires::CalendarEndEvent}
         .each do |i|
        i.ready?.must_equal false
      end
      
      Timecop.travel 1.hour.from_now
      
      cal.items
         .select{|x| x.event.is_a? Wires::CalendarEndEvent}
         .each do |i|
        i.ready?.must_equal true
      end
      
      Timecop.travel 1.hour.ago
      Timecop.travel 1.year.ago
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
