# Copyright © 2025 Lynq Technologies, Inc.
#
# This software is licensed for use pursuant to the terms of the license
# agreement that was executed in order to obtain access to the SDK for
# development purposes. The software can only be used in compliance with the
# terms and conditions of the specific agreement.
#
# @file Makefile


INSTALL_ROOT ?= /opt/lynq

INS_MACHINE ?= $(shell uname -srm | sed -e 's/ /-/g')
INS_PKGNAME ?= NULL
HBPKG_PATH  := ../_hbpkg/$(INS_MACHINE)

LOCAL_SYSTEM := $(shell uname -s)
ifeq ($(LOCAL_SYSTEM),Darwin)
	FINDSTR_PERM := +111
	INSTALL_CMD := ln -s
else ifeq ($(LOCAL_SYSTEM),Linux)
	FINDSTR_PERM := /u=x,g=x,o=x
	INSTALL_CMD := ln -s
else ifeq ($(LOCAL_SYSTEM),CYGWIN_NT-10.0)
    FINDSTR_PERM := /u=x,g=x,o=x
    INSTALL_CMD := cp -R
else
	$(error "LOCAL_SYSTEM set to unknown value: $(LOCAL_SYSTEM)")
endif

# Do not install shared libs yet.
ifneq ($(INS_PKGNAME), NULL)
PKG_SEARCHDIR   := $(HBPKG_PATH)/$(INS_PKGNAME)/
PKG_HEADERFILES	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -name "*.h")
PKG_HEADERDIRS	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 ! -path $(PKG_SEARCHDIR) -type d)
PKG_LIBFILES 	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -name "*.a")
PKG_EXECFILES   := $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -perm $(FINDSTR_PERM) ! -name "*.h" ! -name "*.a" ! -name "*.dylib*" ! -name "*.so*")
SYS_HEADERFILES	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/include/,$(PKG_HEADERFILES))
SYS_HEADERDIRS	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/include/,$(PKG_HEADERDIRS))
SYS_LIBFILES 	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/lib/,$(PKG_LIBFILES))
SYS_EXECFILES   := $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/bin/,$(PKG_EXECFILES))
endif

ifeq ($(INSTALL_CMD),cp -R)
    LN_HEADERFILES	:= $(PKG_HEADERFILES)
    LN_HEADERDIRS	:= $(PKG_HEADERDIRS)
    LN_LIBFILES 	:= $(PKG_LIBFILES)
    LN_EXECFILES    := $(PKG_EXECFILES)
else ifeq ($(INSTALL_CMD),ln -s)
    LN_HEADERFILES	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_HEADERFILES))
    LN_HEADERDIRS	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_HEADERDIRS))
    LN_LIBFILES 	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_LIBFILES))
    LN_EXECFILES    := $(subst ../_hbpkg,../../../_hbpkg,$(PKG_EXECFILES))
else
    $(error "Unexpected Install Command")
endif



all: sys_install

# No package to make
pkg:
	


sys_install:
ifeq ($(INS_PKGNAME), NULL)
	$(error "INS_PKGNAME set to NULL (no installable package specified).")
endif
	@mkdir -p $(INS_MACHINE)/bin
	@mkdir -p $(INS_MACHINE)/include
	@mkdir -p $(INS_MACHINE)/lib
ifneq ($(SYS_HEADERFILES),)
	@echo $(SYS_HEADERFILES) | xargs rm -f
	@$(INSTALL_CMD) $(LN_HEADERFILES) ./$(INS_MACHINE)/include/
endif
ifneq ($(SYS_HEADERDIRS),)
	@echo $(SYS_HEADERDIRS) | xargs rm -rf
	@$(INSTALL_CMD) $(LN_HEADERDIRS) ./$(INS_MACHINE)/include/
endif
ifneq ($(SYS_LIBFILES),)
	@echo $(SYS_LIBFILES) | xargs rm -f 
	@$(INSTALL_CMD) $(LN_LIBFILES) ./$(INS_MACHINE)/lib/
endif
ifneq ($(SYS_EXECFILES),)
	@echo $(SYS_EXECFILES) | xargs rm -f 
	@$(INSTALL_CMD) $(LN_EXECFILES) ./$(INS_MACHINE)/bin/
endif


# May require sudo (depends on your setup of opt)
opt_install:
	@mkdir -p $(INSTALL_ROOT)/bin
	@mkdir -p $(INSTALL_ROOT)/lib
	@mkdir -p $(INSTALL_ROOT)/include
	@cp -R -L $(INS_MACHINE)/bin/* $(INSTALL_ROOT)/bin/
	@cp -R -L $(INS_MACHINE)/lib/* $(INSTALL_ROOT)/lib/
	@cp -R -L $(INS_MACHINE)/include/* $(INSTALL_ROOT)/include/

cleaner: clean
	@$(RM) -rf $(INS_MACHINE)

.PHONY: all pkg sys_install clean
#Non-File Targets

