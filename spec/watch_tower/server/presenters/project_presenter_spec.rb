require 'spec_helper'

module Server
  module Presenters
    describe ProjectPresenter do
      before(:each) do
        @project = FactoryGirl.create :project
      end

      subject { ProjectPresenter.new(@project, nil) }

      it "should return a formatted elapsed time" do
        time = 1.day + 2.hours + 3.minutes + 34.seconds
        subject.stubs(:elapsed_time).returns(time)
        subject.elapsed.should == '1 day, 2 hours, 3 minutes and 34 seconds'
      end
    end
  end
end