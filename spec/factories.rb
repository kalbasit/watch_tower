FactoryGirl.define do
  factory :project, class: Server::Project do
    name
    path
  end

  factory :file, class: Server::File do
    project
    path
  end

  factory :time_entry, class: Server::TimeEntry do
    file
    mtime { Time.now }
  end

  factory :duration, class: Server::Duration do
    file
    date { Time.now }
    duration { Random.rand(1000) }
  end

  sequence :name do |n|
    "project_#{n}"
  end

  sequence :path do |n|
    "/path/to/project_#{n}"
  end
end