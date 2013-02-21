require 'ffi'
require 'ffi-compiler/loader'

module Geokdtree
  module C
    extend FFI::Library
    ffi_lib FFI::Compiler::Loader.find('geokdtree')
  end
end

require 'geokdtree/version'
require 'geokdtree/tree_ffi'
require 'geokdtree/tree'
