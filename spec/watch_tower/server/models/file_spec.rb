require 'spec_helper'

module Server
  describe File do
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
  end
end