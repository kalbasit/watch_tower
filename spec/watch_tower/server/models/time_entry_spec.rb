require 'spec_helper'

module Server
  describe TimeEntry do
    describe "Validations" do
      it { should_not be_valid }

      it "should require an mtime" do
        t = FactoryGirl.build :time_entry, mtime: nil
        t.should_not be_valid
      end

      it "should be valid if attributes requirements are met" do
        t = FactoryGirl.build :time_entry
        t.should be_valid
      end
    end

    describe "Associations" do
      it "should belong to a file" do
        f = FactoryGirl.create :file
        t = FactoryGirl.create :time_entry, file: f

        t.file.should == f
      end
    end
  end
end