require 'mkmf'

$CFLAGS << " -O3 -fPIC -g -DUSE_LIST_NODE_ALLOCATOR"

have_library("pthread")

create_makefile 'geokdtree'