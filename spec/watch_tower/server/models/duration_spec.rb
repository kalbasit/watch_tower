require 'spec_helper'

module Server
  describe Duration do
    describe "Attributes" do
      it { should respond_to :date }

      it { should respond_to :duration }
    end

    describe "Validations" do
      it { should_not be_valid }

      it "should require a file" do
        d = FactoryGirl.build :duration, file: nil
        d.should_not be_valid
      end

      it "should require a date" do
        d = FactoryGirl.build :duration, date: nil
        d.should_not be_valid
      end

      it "should require a duration" do
        d = FactoryGirl.build :duration, duration: nil
        d.should_not be_valid
      end
    end

    describe "Associations" do
      it "should belong to a file" do
        f = FactoryGirl.create :file
        d = FactoryGirl.create :duration, file: f

        d.file.should == f
      end
    end

    describe "#duration" do
      it "should default to 0 for a project with 0 elapsed time" do
        p = FactoryGirl.create :project
        f = FactoryGirl.create :file, project: p
        t = FactoryGirl.create :time_entry, file: f

        p.durations.inject(0) { |count, d| count += d.duration }.should == 0
      end

      it "should correctly be calculated" do
        now = Time.now
        p = FactoryGirl.create :project
        f = FactoryGirl.create :file, project: p
        t1 = FactoryGirl.create :time_entry, file: f, mtime: now
        t2 = FactoryGirl.create :time_entry, file: f, mtime: now + 10.seconds

        p.durations.inject(0) { |count, d| count += d.duration }.should == 10
      end
    end

  end
end