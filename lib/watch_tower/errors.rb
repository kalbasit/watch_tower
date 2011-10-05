module WatchTower
  # Global Error
  WatchTowerError = Class.new Exception

  # Exception used by the Path module
  PathError = Class.new WatchTowerError
  PathNotUnderCodePath = Class.new PathError

  # Exception used by the editors
  EditorError = Class.new WatchTowerError
  TextmateError = Class.new EditorError
  XcodeError = Class.new EditorError
end