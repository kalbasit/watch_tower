# Factory girl
require 'factory_girl'

# Tell factory_girl where to find migrations
FactoryGirl.definition_file_paths << File.expand_path("#{ROOT_PATH}/spec/factories")
FactoryGirl.find_definitions