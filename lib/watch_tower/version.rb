# -*- encoding: utf-8 -*-

module WatchTower
  MAJOR = 0
  MINOR = 0
  TINY = 1
  PRE = 'beta6'

  def self.version
    # Init the version
    version = [MAJOR, MINOR, TINY]
    # Add the pre if available
    version << PRE unless PRE.nil? || PRE !~ /\S/
    # Return the version joined by a dot
    version.join('.')
  end
end
