# Factory girl
require 'factory_girl'

# Include The server module so the factories could work
include Server

# Tell factory_girl where to find migrations
FactoryGirl.definition_file_paths << File.expand_path("#{ROOT_PATH}/spec/factories")
FactoryGirl.find_definitions