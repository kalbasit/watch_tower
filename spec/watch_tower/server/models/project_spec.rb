require 'spec_helper'

module Server
  describe Project do
    describe "Attributes" do
      it { should respond_to :name }
      it { should respond_to :path }
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

      it "should have time_entries through files" # do
       #        file1 = FactoryGirl.create :file, project: @project
       #        file2 = FactoryGirl.create :file, project: @project
       #
       #        10.times do
       #          FactoryGirl.create :time_entry, file: file1
       #        end
       #
       #        10.times do
       #          FactoryGirl.create :time_entry, file: file2
       #        end
       #
       #        @project.reload.time_entries.size.should == 20
       #      end
    end

    describe "TimeEntries count" do
      before(:each) do
        @project = FactoryGirl.create :project
        @file = FactoryGirl.create :file, project: @project
      end

      it "should calculate elapsed time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @project.reload
        @project.elapsed_time.should == 2
      end

      it "should skip the one with pause time" do
        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        Timecop.freeze(Time.now + @file.time_entries.first.send(:pause_time) + 1)
        FactoryGirl.create :time_entry, file: @file, mtime: Time.now

        3.times do
          Timecop.freeze(Time.now + 1)
          FactoryGirl.create :time_entry, file: @file, mtime: Time.now
        end

        @project.reload
        @project.elapsed_time.should == 5
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

        @project.reload
        @project.elapsed_time.should == 2
      end
    end

    describe "scopes" do
      before(:each) do
        @projects = 3.times.collect do
          project = FactoryGirl.create :project
          FactoryGirl.create :file, project: project
          project.reload
        end
      end

      it "should have the default scope to" do
        file = @projects.first.files.first
        10.times do |n|
          Timecop.freeze(Time.now + n * 2)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        file = @projects[1].files.first
        10.times do |n|
          Timecop.freeze(Time.now + n * 10)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        file = @projects.last.files.first
        10.times do |n|
          Timecop.freeze(Time.now + n * 5)
          FactoryGirl.create :time_entry, file: file, mtime: Time.now
        end

        Project.all.first.should == @projects[1]
      end

      it "should have a scope worked_on" do
        Project.should respond_to(:worked_on)
      end

      it "should have a scope worked_on that returns all projects that do not have empty time_entries" do
        file = @projects[0].files.first
        5.times do
          FactoryGirl.create :time_entry, file: file
        end

        file = @projects[1].files.first
        5.times do
          FactoryGirl.create :time_entry, file: file
        end

        Project.worked_on.should_not include(@projects.last)
      end
    end

    describe "Methods" do
      before(:each) do
        @projects = []
        2.times do
          @projects << FactoryGirl.create(:project)
        end

        @projects.each do |p|
          2.times do
            f = FactoryGirl.create(:file, project: p)
            2.times do
              FactoryGirl.create :time_entry, file: f
            end
          end
        end
      end

      describe "#elapsed_time" do
        it { should respond_to :elapsed_time }

        it "should have the right elapsed_time" do
          @projects.first.elapsed_time.should == 4
        end
      end


      describe "#sum_elapsed_time" do
        it "should respond_to sum_elapsed_time" do
          Project.should respond_to(:sum_elapsed_time)
        end

        it "should return the sum of all elapsed times of all projects" do
          Project.sum_elapsed_time.should == @projects.inject(0) {|s, p| s += p.elapsed_time }
        end
      end

      describe "#percent" do
        it { should respond_to :percent }

        it "should return 50" do
          @projects.first.percent.should == 50
        end
      end
    end
  end
end