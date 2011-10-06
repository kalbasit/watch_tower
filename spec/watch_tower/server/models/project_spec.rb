require 'spec_helper'

module Server
  describe Project do
    describe "Attributes" do
      it { should respond_to :name }
      it { should respond_to :path }
      it { should respond_to :elapsed_time }
      it { should respond_to :files_count }
    end

    describe "Validations" do
      it { should_not be_valid }

      it "should require a name" do
        m = FactoryGirl.build :project, name: nil
        m.should_not be_valid
      end

      it "should require a path" do
        m = FactoryGirl.build :project, path: nil
        m.should_not be_valid
      end

      it "should be valid if attributes requirements are met" do
        m = FactoryGirl.build :project
        m.should be_valid
      end
    end

    describe "Associations" do
      before(:each) do
        @project = FactoryGirl.create :project
      end
      it { should respond_to :files }
      it { should respond_to :time_entries }

      it "should increment the counter cache" do
        10.times do
          FactoryGirl.create :file, project: @project
        end

        @project.reload.files_count.should == 10
      end

      it "should have time_entries through files" do
        file1 = FactoryGirl.create :file, project: @project
        file2 = FactoryGirl.create :file, project: @project

        10.times do
          FactoryGirl.create :time_entry, file: file1
        end

        10.times do
          FactoryGirl.create :time_entry, file: file2
        end

        @project.reload.time_entries.size.should == 20
      end
    end

    describe "TimeEntries count" do
      before(:each) do
        @project = FactoryGirl.create :project
        @file = FactoryGirl.create :file, project: @project
      end

      it "should calculate elapsed time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file
        end

        @project.reload
        @project.elapsed_time.should == 2
      end

      it "should skip the one with pause time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file
        end

        Timecop.freeze(Time.now + TimeEntry::PAUSE_TIME + 1)
        FactoryGirl.create :time_entry, file: @file

        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file
        end

        @project.reload
        @project.elapsed_time.should == 5
      end

      it "should not count the time entries of another file" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file
        end

        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry
        end

        @project.reload
        @project.elapsed_time.should == 2
      end
    end
  end
end