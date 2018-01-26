# vim linux build

> portably build and install upstream vim in Linux

This fork just adds another makefile to build and install vim from source in
Ubuntu, Debian or Arch Linux.

Run `make -f build-kba.mk help` for documentation.

Run `make -f build-kba.mk full-rebuild` to just install with useful defaults to `/usr/local`.

## `make -f build-kba.mk help`

<!-- BEGIN-EVAL make -f build-kba.mk help -->


  Targets

    build         configure and build but not install
    full-rebuild  clean, build, install

  Variables

    LUA_VERSION      Lua version
    RUBY_VERSION     Ruby version
    PERL_VERSION     Perl version
    PYTHON2_VERSION  Python2 version
    PYTHON3_VERSION  Python3 version
    JOBS             Concurrent make jobs

<!-- END-EVAL -->
