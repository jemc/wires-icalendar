$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))
require 'wires/icalendar'

require 'wires/test'
begin require 'jemc/reporter'; rescue LoadError; end


$testcal = File.expand_path('./spec/fixtures/life.ics', File.dirname(__FILE__))

describe Wires::Calendar do
  describe "#new_from" do
    it "can create by parsing from a filepath"
    it "can create by parsing a File object"
  end
end




