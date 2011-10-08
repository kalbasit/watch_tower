require 'spec_helper'

module Server
  module Presenter
    describe Project do
      it "should return a formatted elapsed time" do
        time = 1.day + 2.hours + 3.minutes + 34.seconds
        subject.stubs(:elapsed_time).returns(time)
        subject.elapsed.should == '1 day, 2 hours, 3 minutes and 34 seconds'
      end
    end
  end
end