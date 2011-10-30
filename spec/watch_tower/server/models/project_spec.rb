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

      it "should have many time entries through files" do
        f = FactoryGirl.create :file, project: @project
        t = FactoryGirl.create :time_entry, file: f

        @project.reload.time_entries.should include(t)
      end

      it "should have many durations through files" do
        f = FactoryGirl.create :file, project: @project

        2.times do
          FactoryGirl.create :time_entry, file: f
        end

        @project.reload.durations.should_not be_empty
        @project.reload.durations.should include(Duration.first)
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
      describe "#elapsed_time" do
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

        it { should respond_to :elapsed_time }

        it "should have the right elapsed_time" do
          @projects.first.elapsed_time.should == 4
        end
      end


      describe "#sum_elapsed_time" do
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

        it "should respond_to sum_elapsed_time" do
          Project.should respond_to(:sum_elapsed_time)
        end

        it "should return the sum of all elapsed times of all projects" do
          Project.sum_elapsed_time.should == @projects.inject(0) {|s, p| s += p.elapsed_time }
        end
      end

      describe "#date_range" do
        before(:each) do
          @tw_projects = []
          @lw_projects = []
          # Freeze the time to this week
          Timecop.freeze(Time.now)
          # Create a bunch of projects
          2.times do
            @tw_projects << FactoryGirl.create(:project)
            2.times do
              f = FactoryGirl.create(:file, project: @tw_projects.last)
              2.times do |n|
                FactoryGirl.create(:time_entry, file: f)
              end
            end
          end
          # Freeze the time to last week
          Timecop.freeze(Time.now - 7.days)
          # Create a bunch of projects
          2.times do
            @lw_projects << FactoryGirl.create(:project)
            2.times do
              f = FactoryGirl.create(:file, project: @lw_projects.last)
              2.times do
                FactoryGirl.create(:time_entry, file: f)
              end
            end
          end
          # Return the frozen time to now
          Timecop.freeze(Time.now + 7.days)
        end

        subject { Project }

        it { should respond_to :date_range }

        it "should return an active relation object" do
          from = (Time.now - 6.days).strftime '%m/%d/%Y'
          to = Time.now.strftime '%m/%d/%Y'

          q = subject.date_range from, to
          q.should be_instance_of ActiveRecord::Relation
        end

        it "should not return project's of last week" do
          from = (Time.now - 6.days).strftime '%m/%d/%Y'
          to = Time.now.strftime '%m/%d/%Y'

          q = subject.date_range from, to
          @lw_projects.each {|p| q.should_not include(p)}
        end
      end

      describe "#percent" do
        before(:each) do
          @projects = []
          2.times do
            @projects << FactoryGirl.create(:project)
          end

          Timecop.freeze(Time.now)
          @projects.each do |p|
            2.times do
              f = FactoryGirl.create(:file, project: p)
              2.times do |n|
                FactoryGirl.create :time_entry, file: f, mtime: Time.now + 2 * n
              end
            end
          end
        end

        it { should respond_to :percent }

        it "should return 50" do
          @projects.first.percent.should == 50
        end
      end

      describe "#recalculate_elapsed_time" do
        before(:each) do
          @project = FactoryGirl.create(:project)
          @files = []
          Timecop.freeze(Time.now)
          2.times do
            @files << FactoryGirl.create(:file, project: @project)
            2.times do |n|
              FactoryGirl.create :time_entry, file: @files.last, mtime: Time.now + 2 * n
            end
          end
          Timecop.return

          @project.reload
          @elapsed_time = @project.elapsed_time
        end

        subject { @project }

        it { should respond_to(:recalculate_elapsed_time) }

        it "should calculate the correct elapsed_time" do
          subject.elapsed_time = -56456
          subject.save

          subject.recalculate_elapsed_time
          subject.reload.elapsed_time.should == @elapsed_time
        end
      end
    end
  end
end
