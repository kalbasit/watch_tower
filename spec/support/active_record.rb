# Include only Rspec's active record functionalities
require 'rspec/rails/extensions/active_record/base'
require 'rspec/rails/adapters'
require 'rspec/rails/matchers/be_a_new'
require 'rspec/rails/matchers/be_new_record'
require 'rspec/rails/matchers/have_extension'
# Uncomment for 2.6.2
# require 'rspec/rails/matchers/relation_match_array'
require 'rspec/rails/fixture_support'
require 'rspec/rails/mocks'
require 'rspec/rails/example/rails_example_group'
require 'rspec/rails/example/model_example_group'

RSpec::configure do |config|
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]'))
  end unless config.respond_to? :escaped_path

  config.include RSpec::Rails::ModelExampleGroup, :type => :model, :example_group => {
    :file_path => config.escaped_path(%w[spec watch_tower server models])
  }

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # This is a hack to empty up the database before each test
  # I wasn't able to replicate what Rails / RSpec does for the test suite
  # I'd appreciate any hints to speed up the test suite.
  config.before(:each) do
    WatchTower::Server.constants.                         # Collect the defined constants
      collect { |c| "::WatchTower::Server::#{c}"}.        # Access them under the Server module
      collect(&:constantize).                             # Make them a constant
      select { |c| c.class == Class }.                    # Keep only classes
      select { |c| c.superclass == ActiveRecord::Base }.  # Keep only those with superclass ActiveRecord::Base
      each(&:delete_all)                                  # Run delete_all on each class
  end

  # Start the server before all examples
  config.before(:all) do
    WatchTower::Server::Database.start!
  end
end