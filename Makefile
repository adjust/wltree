# contrib/wltree/Makefile

MODULE_big = wltree
OBJS = 	ltree_io.o ltree_op.o lquery_op.o _ltree_op.o crc32.o \
	ltxtquery_io.o ltxtquery_op.o ltree_gist.o _ltree_gist.o
PG_CPPFLAGS = -DLOWER_NODE

EXTENSION = wltree
DATA = wltree--2.0.sql wltree--unpackaged--2.0.sql wltree--dummy.sql wltree--dummy--2.0.sql

REGRESS = wltree

PG_CONFIG ?= pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
