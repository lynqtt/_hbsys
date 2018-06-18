INS_MACHINE ?= $(shell uname -srm | sed -e 's/ /-/g')
INS_PKGNAME ?= NULL
HBPKG_PATH  := ../_hbpkg/$(INS_MACHINE)

#ifeq ($(INS_PRODUCT), NULL)
#	error "INS_PRODUCT set to NULL (no install specified)."
#endif
ifeq ($(INS_PKGNAME), NULL)
	error "INS_PKGNAME set to NULL (no installable package specified)."
endif

LOCAL_SYSTEM := $(shell uname -s)
ifeq ($(LOCAL_SYSTEM),Darwin)
	FINDSTR_PERM := +111
else ifeq ($(LOCAL_SYSTEM),Linux)
	FINDSTR_PERM := /u=x,g=x,o=x
else
	error "THISSYSTEM set to unknown value: $(THISSYSTEM)"
endif

# Do not install shared libs yet.  Too much pain with these shared libs.
PKG_SEARCHDIR   := $(HBPKG_PATH)/$(INS_PKGNAME)/
PKG_HEADERFILES	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -name "*.h")
PKG_HEADERDIRS	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 ! -path $(PKG_SEARCHDIR) -type d)
#PKG_LIBFILES 	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -name "*.a" -or -name "*.dylib*" -or -name "*.so*")
PKG_LIBFILES 	:= $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -name "*.a")
PKG_EXECFILES   := $(shell find $(PKG_SEARCHDIR) -maxdepth 1 -type f -perm $(FINDSTR_PERM) ! -name "*.h" ! -name "*.a" ! -name "*.dylib*" ! -name "*.so*")
SYS_HEADERFILES	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/include/,$(PKG_HEADERFILES))
SYS_HEADERDIRS	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/include/,$(PKG_HEADERDIRS))
SYS_LIBFILES 	:= $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/lib/,$(PKG_LIBFILES))
SYS_EXECFILES   := $(subst $(PKG_SEARCHDIR),./$(INS_MACHINE)/bin/,$(PKG_EXECFILES))
LN_HEADERFILES	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_HEADERFILES))
LN_HEADERDIRS	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_HEADERDIRS))
LN_LIBFILES 	:= $(subst ../_hbpkg,../../../_hbpkg,$(PKG_LIBFILES))
LN_EXECFILES    := $(subst ../_hbpkg,../../../_hbpkg,$(PKG_EXECFILES))




all: sys_install




sys_install:
	@mkdir -p $(INS_MACHINE)/bin
	@mkdir -p $(INS_MACHINE)/include
	@mkdir -p $(INS_MACHINE)/lib
ifneq ($(SYS_HEADERFILES),)
	@echo $(SYS_HEADERFILES) | xargs rm -f
	@ln -s $(LN_HEADERFILES) ./$(INS_MACHINE)/include/
endif
ifneq ($(SYS_HEADERDIRS),)
	@echo $(SYS_HEADERDIRS) | xargs rm -f
	@ln -s $(LN_HEADERDIRS) ./$(INS_MACHINE)/include/
endif
ifneq ($(SYS_LIBFILES),)
	@echo $(SYS_LIBFILES) | xargs rm -f 
	@ln -s $(LN_LIBFILES) ./$(INS_MACHINE)/lib/
endif
ifneq ($(SYS_EXECFILES),)
	@echo $(SYS_EXECFILES) | xargs rm -f 
	@ln -s $(LN_EXECFILES) ./$(INS_MACHINE)/bin/
endif




#Non-File Targets
.PHONY: all sys_install clean cleaner

