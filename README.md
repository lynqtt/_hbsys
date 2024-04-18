# HBsys: A Simple Build and Package Management Tool

HBsys (stored in directory named "_hbsys" for the purpose of ordering within a root directory) provides a **makefile** that works together with child makefiles from compliant software components.  

The point of HBsys is to provide a build system for a group of embedded software, typically deployed together as middleware, without resorting to build systems like cMake or BitBake.  HBsys is not as versatile or generic as these, but it can be deployed to virutually any system that has supports the C programming language because it uses only Makefiles.

Incomplete list of software that builds with HBsys:

* [argtable](https://github.com/jpnorair/argtable)
* [bintex](https://github.com/jpnorair/bintex)
* [clithread](https://github.com/jpnorair/clithread)
* [cmdtab](https://github.com/jpnorair/cmdtab)
* [hbutils](https://github.com/jpnorair/hbutils)
* [otter](https://github.com/lynqtt/otter2)
* [ottercat](https://github.com/jpnorair/ottercat)
* [otvar](https://github.com/jpnorair/otvar)
* [sciclient](https://github.com/lynqtt/sciclient)

## Customization of Build & Management

The HBsys API is your text editor.  It is based on simple makefiles.  There is no proprietary API to learn.  Just fork the project and customize it however you see fit.

## Usage

There are three high-level things you can do with HBsys.  

1. **sys-install**: Add already-built, HB-compliant packages to HBsys management (via `_hbsys/makefile`).
1. **opt-install**: Install a distribution of software programs managed by HBsys into `/opt` tree (via `_hbsys/makefile`).
1. **pkg**: create an HB-compliant software package (via HB-compliant software makefile) 

### sys-install

```
$ cd _hbsys
$ make sys-install
```

**Note**: `make` or `make all` alias to `make sys-install`

What happens here, is that all the software packaged in the `_hbpkg` directory (this is created by **pkg** operation if it doesn't already exist), and matching the system information of the local build system (e.g. Linux-4.4.0-137-generic-x86\_64, Darwin-18.7.0-x86\_64, etc), will get symlinked into a corresponding directory within `_hbsys`.  You can include and link from headers and libraries, respectively, within the `_hbsys` hierarchy.

### opt-install

```
$ cd _hbsys
$ make opt-install
```

After running **sys-install**, you can copy a distribution of executable software inclusive in `_hbsys` (i.e. the `bin` subdirectory) into a tree starting with `/opt`

### pkg

```
$ cd __some_hb-compliant_repo__
$ make pkg
```

All software that builds with HBsys will contain individual, local makefiles.  Running `make pkg` will build a package of whatever that software requires and copy it to a corresponding subdirectory within `_hbpkg`.  It is the duty of the local makefile to specify what exactly `make pkg` will build (e.g. it could be a program, a library, or just a header file).
