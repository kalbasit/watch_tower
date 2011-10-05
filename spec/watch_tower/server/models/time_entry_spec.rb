require 'spec_helper'

module Server
  describe TimeEntry do
    describe "Validations" do
      it { should_not be_valid }

      it "should require an mtime" do
        m = FactoryGirl.build :time_entry, mtime: nil
        m.should_not be_valid
      end

      it "should be valid if attributes requirements are met" do
        m = FactoryGirl.build :time_entry
        m.should be_valid
      end
    end
  end
end