require 'spec_helper'

module Server
  describe File do
    describe "Attributes" do
      it { should respond_to :path }
      it { should respond_to :elapsed_time }
      it { should respond_to :time_entries_count }
    end

    describe "Validations" do
      it { should_not be_valid }

      it "should require an path" do
        m = FactoryGirl.build :file, path: nil
        m.should_not be_valid
      end

      it "should require a project" do
        m = FactoryGirl.build :file, project: nil
        m.should_not be_valid
      end

      it "should be valid if attributes requirements are met" do
        m = FactoryGirl.build :file
        m.should be_valid
      end
    end

    describe "Associations" do
      before(:each) do
        @file = FactoryGirl.create :file
      end

      it { should respond_to :project }
      it { should respond_to :time_entries }

      it "should increment the counter cache" do
        10.times do
          FactoryGirl.create :time_entry, file: @file
        end

        @file.reload.time_entries_count.should == 10
      end

      it "should belong to a project" do
        project = FactoryGirl.create :project
        file = FactoryGirl.create :file, project: project

        file.project.should == project
      end
    end

    describe "TimeEntries count" do
      before(:each) do
        @file = FactoryGirl.create :file
      end

      it "should calculate elapsed time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @file.reload
        @file.elapsed_time.should == 2
      end

      it "should skip the one with pause time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        Timecop.freeze(Time.now + TimeEntry::PAUSE_TIME + 1)
        FactoryGirl.create :time_entry, file: @file, mtime: Time.now

        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @file.reload
        @file.elapsed_time.should == 5
      end

      it "should not count the time entries of another file" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, mtime: Time.now
        end

        @file.reload
        @file.elapsed_time.should == 2
      end

      it "should add duration to a different day (2 days)." do
        # Create initial time entries
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        # Go ahead one day
        Timecop.freeze(Time.now + 1.day)

        # Add 3 more time entries
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @file.reload
        @file.elapsed_time.should == 4
        @file.durations.size.should == 2
      end

      it "should correctly record dates" do
        # Record the date of the first day
        Timecop.freeze(Time.now)
        current_day = Time.now.to_date

        # Create initial time entries
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        # Go ahead one day
        Timecop.freeze(Time.now + 1.day)
        next_day = Time.now.to_date

        # Add 3 more time entries
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @file.reload
        @file.durations.order('id ASC').first.date.should == current_day
        @file.durations.order('id ASC').last.date.should == next_day
      end
    end

    describe "scopes" do
      before(:each) do
        @files = 3.times.collect{ FactoryGirl.create :file }
      end

      it "should have the default scope to" do
        10.times do |n|
          file = @files.first
          Timecop.freeze(Time.now + n * 2)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        10.times do |n|
          file = @files[1]
          Timecop.freeze(Time.now + n * 10)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        10.times do |n|
          file = @files.last
          Timecop.freeze(Time.now + n * 5)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        File.all.first.should == @files[1]
      end

      it "should have a scope worked_on" do
        File.should respond_to(:worked_on)
      end

      it "should have a scope worked_on that returns all projects that do not have empty time_entries" do
        5.times do
          FactoryGirl.create :time_entry, file: @files[0]
        end

        5.times do
          FactoryGirl.create :time_entry, file: @files[1]
        end

        File.worked_on.should_not include(@files.last)
      end
    end
  end
end