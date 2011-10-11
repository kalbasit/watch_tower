require 'timecop'

RSpec.configure do |config|
  config.before(:each) do
    Timecop.return
  end
end