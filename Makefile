INS_MACHINE ?= $(shell uname -srm | sed -e 's/ /-/g')
INS_TYPE    ?= lib
INS_PRODUCT ?= NULL
INS_PATH    ?= NULL
HBPKG_PATH  ?= ../_hbpkg/$(INS_MACHINE)

ifeq ($(INS_PRODUCT), NULL)
	error "INS_PRODUCT set to NULL (no install specified)."
endif
ifeq ($(INS_PATH), NULL)
	error "INS_PATH set to NULL (no path to installable lib/app specified)."
endif


HEADER_FILEPATHS    := $(shell find $(INS_PATH)/ ! -path $(INS_PATH)/ -maxdepth 1 -type d)
HEADER_DIRPATHS     := $(shell find $(INS_PATH)/ -maxdepth 1 -name "*.h")
HEADER_FILES        := 
HEADER_DIRS         := 


all: sys_install

sys_install:
	@mkdir -p $(INS_MACHINE)/bin
	@mkdir -p $(INS_MACHINE)/include
	@mkdir -p $(INS_MACHINE)/lib
	@


#Non-File Targets
.PHONY: all sys_install clean cleaner

