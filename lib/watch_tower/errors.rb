module WatchTower
  # Global Error
  WatchTowerError = Class.new Exception

  # Exceptions raised by the Project
  ProjectError = Class.new WatchTowerError

  # Exception used by the Path module
  PathError = Class.new ProjectError
  PathNotUnderCodePath = Class.new PathError

  # Exception used by the editors
  EditorError = Class.new WatchTowerError
  TextmateError = Class.new EditorError
  XcodeError = Class.new EditorError

  # Exceptions used by the server
  ServerError = Class.new WatchTowerError
  DatabaseError = Class.new ServerError
end