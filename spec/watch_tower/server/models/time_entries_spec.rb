require 'spec_helper'

module Server
  describe TimeEntries do
    describe "Validations" do
      it { should_not be_valid }

      it "should require a path" do
        m = FactoryGirl.build :time_entries, path: nil
        m.should_not be_valid
      end

      it "should require an mtime" do
        m = FactoryGirl.build :time_entries, mtime: nil
        m.should_not be_valid
      end

      it "should be valid if attributes requirements are met" do
        m = FactoryGirl.build :time_entries
        m.should be_valid
      end
    end
  end
end