mkfile_path  := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir  := $(notdir $(patsubst %/,%,$(dir $(realpath $(mkfile_path)/../))))
top_builddir := $(basename $(patsubst %/,%,$(dir $(mkfile_path))))
# Makefile includes
build_aux    := $(top_builddir)/build-aux

# Include vars
include $(build_aux)/vars/ansicolor_vars.mk
include $(build_aux)/vars/help.mk

