# -*- encoding: utf-8 -*-

module WatchTower
  # Global Error
  WatchTowerError = Class.new Exception

  # Exceptions raised by the Project module
  ProjectError = Class.new WatchTowerError
  FileNotFound = Class.new ProjectError

  # Exception raised by the Path module
  PathError = Class.new ProjectError
  PathNotUnderCodePath = Class.new PathError

  # Appscript errors
  AppscriptNotLoadedError = Class.new WatchTowerError

  # Exception raised by the Editor module
  EditorError = Class.new WatchTowerError
  TextmateError = Class.new EditorError
  XcodeError = Class.new EditorError
  VimError = Class.new EditorError
  VimVersionNotPrinted = Class.new VimError

  # Exceptions raised by the Server module
  ServerError = Class.new WatchTowerError
  DatabaseError = Class.new ServerError
  DatabaseConfigNotFoundError = Class.new DatabaseError

  # Exceptions raised by the Eye module
  EyeError = Class.new WatchTowerError
end
