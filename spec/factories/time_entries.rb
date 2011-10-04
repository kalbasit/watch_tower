FactoryGirl.define do
  factory :time_entries, class: TimeEntries do
    path '/path/to/file.rb'
    mtime { Time.now }
  end
end
