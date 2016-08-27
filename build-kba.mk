#!/bin/make

COMPILED_BY = $(shell id -un; echo '@'; hostname)
PREFIX = /usr/local

FEATURES = huge # big, normal, small tiny

LUA_VERSION = 5.1
RUBY_VERSION = 2.1
PERL_VERSION = 5.20
PYTHON2_VERSION = 2.7
PYTHON3_VERSION = 3.4

#=============================================================================#
#
# Essentials
#
DEBS += build-essential
DEBS += libncurses5-dev
CONFIGURE_FLAGS += --with-features=$(FEATURES)
CONFIGURE_FLAGS += --with-compiledby="$(COMPILED_BY)"
CONFIGURE_FLAGS += --enable-fail-if-missing
CONFIGURE_FLAGS += --prefix=$(PREFIX)
CONFIGURE_FLAGS += --enable-multibyte
#------------------------------------------------------------------------------


#=============================================================================#
#
# For X11
#
DEBS += libgnome2-dev
DEBS += libgnomeui-dev
DEBS += libgtk2.0-dev
DEBS += libatk1.0-dev
DEBS += libbonoboui2-dev
DEBS += libcairo2-dev
DEBS += libx11-dev
DEBS += libxpm-dev
DEBS += libxt-dev
CONFIGURE_FLAGS += --enable-netbeans
CONFIGURE_FLAGS += --enable-gui=auto
CONFIGURE_FLAGS += --enable-gtk2-check
CONFIGURE_FLAGS += --enable-gnome-check
CONFIGURE_FLAGS += --with-x
#------------------------------------------------------------------------------


#==============================================================================
#
# Lua
#
DEBS += luajit
DEBS += libluajit-$(LUA_VERSION)-dev
CONFIGURE_FLAGS += --enable-luainterp=yes
CONFIGURE_FLAGS += --with-luajit
#------------------------------------------------------------------------------


#==============================================================================
#
# Perl
#
DEBS += libperl5.20
DEBS += libperl-dev
CONFIGURE_FLAGS += --enable-perlinterp=yes
#------------------------------------------------------------------------------


#==============================================================================
#
# Python 2
#
# DEBS += libpython$(PYTHON2_VERSION)-dev
CONFIGURE_FLAGS += --enable-pythoninterp=yes
#------------------------------------------------------------------------------


#==============================================================================
#
# Python 3
#
DEBS += python$(PYTHON3_VERSION)
DEBS += python$(PYTHON3_VERSION)-dev
DEBS += python3-dev
CONFIGURE_FLAGS += --enable-python3interp=dynamic
CONFIGURE_FLAGS += --with-python3-config-dir=$(shell python3-config --configdir)
#------------------------------------------------------------------------------


#==============================================================================
#
# Ruby
#
DEBS += libruby$(RUBY_VERSION)
DEBS += ruby$(RUBY_VERSION)-dev
CONFIGURE_FLAGS += "--enable-rubyinterp=yes"
#------------------------------------------------------------------------------


.PHONY: apt-get fix-lua prepare clean full-rebuild

prepare: fix-lua
	./configure $(CONFIGURE_FLAGS)

apt-get:
	-sudo apt-get install -y $(DEBS)

fix-lua:
	-sudo ln -s /usr/include/lua$(LUA_VERSION) /usr/include/lua$(LUA_VERSION)/include
	-sudo ln -s /usr/lib/x86_64-linux-gnu/liblua$(LUA_VERSION).so /usr/local/lib/liblua.so

distclean:
	$(MAKE) distclean

full-rebuild: distclean prepare
	$(MAKE) && sudo $(MAKE) install
