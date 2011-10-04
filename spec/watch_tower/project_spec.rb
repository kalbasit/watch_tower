require 'spec_helper'

describe Project do
  # it { should respond_to :name }
  # it { should respond_to :path }

  describe "Class Methods" do
    subject { Project }
    it { should respond_to :new_from_path }
  end

  describe "Instance Methods" do
    subject { Project.new }

  end
end
