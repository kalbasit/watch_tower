require 'spec_helper'
require 'watch_tower/appscript'

describe ::Appscript do
  it { should be_kind_of(Module) }
  it { should respond_to :app }
end
