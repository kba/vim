#!/bin/make

COMPILED_BY = $(shell echo "`id -un`@`hostname`")
PREFIX = /usr/local

DISTRO=$(shell grep -h 'ID=' /etc/*-release \
	   |head -n1 \
	   |sed 's,ID=,,' \
	   |sed 's/DISTRIB_Ubuntu/ubuntu/' \
	   )

FEATURES = huge # big, normal, small tiny

LUA_VERSION = 5.1
RUBY_VERSION = 2.3
PERL_VERSION = 5.22
PYTHON2_VERSION = 2.7
PYTHON3_VERSION = 3.5
JOBS = 2

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
PAC += luajit
CONFIGURE_FLAGS += --enable-luainterp=yes
CONFIGURE_FLAGS += --with-luajit
#------------------------------------------------------------------------------


#==============================================================================
#
# Perl
#

DEBS += libperl$(PERL_VERSION)
DEBS += libperl-dev
CONFIGURE_FLAGS += --enable-perlinterp=yes
#------------------------------------------------------------------------------


#==============================================================================
#
# Python 2
#
PYTHON2_CONFIG_DIR = $(shell python2 -c \
					 "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LIBPL'))")
DEBS += python-dev
CONFIGURE_FLAGS += --enable-pythoninterp=yes
CONFIGURE_FLAGS += --with-python-config-dir=$(PYTHON2_CONFIG_DIR)
#------------------------------------------------------------------------------


#==============================================================================
#
# Python 3
#
PYTHON3_CONFIG_DIR = $(shell python3 -c \
					 "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LIBPL'))")
DEBS += python$(PYTHON3_VERSION)
DEBS += python$(PYTHON3_VERSION)-dev
DEBS += python3-dev
CONFIGURE_FLAGS += --enable-python3interp=dynamic
CONFIGURE_FLAGS += --with-python3-config-dir=$(PYTHON3_CONFIG_DIR)
#------------------------------------------------------------------------------


#==============================================================================
#
# Ruby
#
DEBS += libruby$(RUBY_VERSION)
DEBS += ruby$(RUBY_VERSION)-dev
CONFIGURE_FLAGS += "--enable-rubyinterp=yes"
#------------------------------------------------------------------------------


THIS_MAKEFILE = $(lastword $(MAKEFILE_LIST))


help:
	@echo "Targets"
	@echo "    build"
	@echo "    deps"
	@echo "    full-rebuild"
	@echo "DISTRO     $(DISTRO)"
	@echo "PYTHON2_CONFIG_DIR = $(PYTHON2_CONFIG_DIR)"
	@echo "PYTHON3_CONFIG_DIR = $(PYTHON3_CONFIG_DIR)"

build: help
	./configure $(CONFIGURE_FLAGS)
	cd src && $(MAKE) -j $(JOBS)

deps-ubuntu:
	sudo apt-get install -y $(DEBS);

deps-debian:
	sudo apt-get install -y $(DEBS);
	sudo ln -si /usr/include/lua$(LUA_VERSION) /usr/include/lua$(LUA_VERSION)/include;
	sudo ln -si /usr/lib/x86_64-linux-gnu/liblua$(LUA_VERSION).so /usr/local/lib/liblua.so;

deps-arch:
	sudo pacman --noconfirm -S $(PAC); \

deps:
	echo "$(DISTRO)"
	-$(MAKE) -f $(THIS_MAKEFILE) deps-$(DISTRO)

full-rebuild:
	$(MAKE) distclean
	$(MAKE)
	sudo $(MAKE) install
