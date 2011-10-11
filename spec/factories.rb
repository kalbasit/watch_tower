FactoryGirl.define do
  factory :project, class: Server::Project do
    name
    path
  end

  factory :file, class: Server::File do
    project
    file_hash
    path
  end

  factory :time_entry, class: Server::TimeEntry do
    file
    file_hash
    mtime
  end

  factory :duration, class: Server::Duration do
    file
    date
    duration { Random.rand(1000) }
  end

  sequence :name do |n|
    "project_#{n}"
  end

  sequence :path do |n|
    "/path/to/project_#{n}"
  end

  sequence :mtime do |n|
    Time.now + 2 * n
  end

  sequence :date do |n|
    Time.now + 2 * n
  end

  sequence :file_hash do |n|
    require 'digest/sha1'
    Digest::SHA1.hexdigest('WatchTower' * n)
  end
end