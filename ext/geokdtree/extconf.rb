require 'mkmf'

$CFLAGS << " -DUSE_LIST_NODE_ALLOCATOR"

have_library("pthread")

create_makefile 'geokdtree'