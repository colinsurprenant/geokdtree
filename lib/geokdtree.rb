require 'ffi'

module Geokdtree
  module C
    extend FFI::Library
    
  	ffi_lib File.dirname(__FILE__) + "/" + (FFI::Platform.mac? ? "geokdtree.bundle" : FFI.map_library_name("geokdtree"))
  end
end

require 'geokdtree/version'
require 'geokdtree/tree_ffi'
require 'geokdtree/tree'
