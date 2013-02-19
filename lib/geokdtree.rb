require 'ffi'

module Geokdtree
  module C
    extend FFI::Library
  end
end

require 'geokdtree/version'
require 'geokdtree/tree_ffi'
require 'geokdtree/tree'
