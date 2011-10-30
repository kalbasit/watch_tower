# Include only Rspec's active record functionalities
require 'rspec/rails/extensions/active_record/base'
require 'rspec/rails/adapters'
require 'rspec/rails/matchers/be_a_new'
require 'rspec/rails/matchers/be_new_record'
require 'rspec/rails/matchers/have_extension'
# TODO: Uncomment When rspec-rails-2.6.2 is released
# require 'rspec/rails/matchers/relation_match_array'
require 'rspec/rails/fixture_support'
require 'rspec/rails/mocks'
require 'rspec/rails/example/rails_example_group'
require 'rspec/rails/example/model_example_group'

RSpec::configure do |config|
  config.include RSpec::Rails::ModelExampleGroup, :type => :model, :example_group => {
    :file_path => config.escaped_path(%w[spec watch_tower server models])
  }

  config.around(:each) do |example|
    # Make sure the connection is open before open a transaction
    WatchTower::Server::Database.start!
    # Increment the number of open transactions
    ActiveRecord::Base.connection.increment_open_transactions
    # Begin a database transaction
    ActiveRecord::Base.connection.begin_db_transaction
    begin
      # Call the example
      example.call
    ensure
      # Rollback the transaction
      ActiveRecord::Base.connection.rollback_db_transaction
      # Decrement the number of open transactions
      ActiveRecord::Base.connection.decrement_open_transactions
    end
  end

  # Start the server before all examples
  config.before(:all) do
    WatchTower::Server::Database.start!
  end

  # Stop the server after all examples
  config.after(:all) do
    WatchTower::Server::Database.stop!
  end
end
