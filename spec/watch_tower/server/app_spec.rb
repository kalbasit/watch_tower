require 'spec_helper'

module Server
  describe App do
    before(:each) do
      @project = FactoryGirl.create :project
      @file = FactoryGirl.create :file, project: @project
      @time_entry = FactoryGirl.create :time_entry, file: @file
      @duration = FactoryGirl.create :duration, file: @file
    end

    describe "#index" do
      it "should render the layout" do
        visit '/'

        page.should have_selector :xpath, '//html/head/title'
      end
    end
  end
end