require 'spec_helper'

module Server
  module Presenters
    describe ApplicationPresenter do

      describe "Instance Methods" do
        before(:each) do
          @model = mock
          @model.stubs(:id).returns(1)
          @model.stubs(:elapsed_time).returns(1234)
        end

        subject { ApplicationPresenter.new(@model, nil) }

        describe "#humanize_time" do
          it "should return 1 second" do
            subject.send(:humanize_time, 1).should == '1 second'
          end

          it "should return 2 seconds" do
            subject.send(:humanize_time, 2).should == '2 seconds'
          end

          it "should return 1 minute" do
            subject.send(:humanize_time, 1.minute).should == '1 minute'
          end

          it "should return 2 minutes" do
            subject.send(:humanize_time, 2.minutes).should == '2 minutes'
          end

          it "should return 1 hour" do
            subject.send(:humanize_time, 1.hour).should == '1 hour'
          end

          it "should return 2 hours" do
            subject.send(:humanize_time, 2.hours).should == '2 hours'
          end

          it "should return 1 day" do
            subject.send(:humanize_time, 1.day).should == '1 day'
          end

          it "should return 2 days" do
            subject.send(:humanize_time, 2.days).should == '2 days'
          end

          it "should return 1 day, 2 hours, 3 minutes and 34 seconds" do
            time = 1.day + 2.hours + 3.minutes + 34.seconds
            subject.send(:humanize_time, time).should == '1 day, 2 hours, 3 minutes and 34 seconds'
          end
        end
      end

      describe "Class Methods" do
        subject { ApplicationPresenter }

        describe "#presents" do
          it { should respond_to :presents }

          it "should create a method the same name as the argument passed to presents" do
            Class.new(subject) do
              presents :foo
            end.new(@project, nil).should respond_to :foo
          end
        end
      end
    end
  end
end
