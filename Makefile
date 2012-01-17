#!/usr/bin/make -f

LIBROOT_MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))
LIBROOT_BASE?=$(dir $(LIBROOT_MAKEFILE))

TARBALL?=$(shell ls root_v*.source.tar.gz|tail -n 1)
VERSION?=$(patsubst root_v%.source.tar.gz,%,$(notdir $(TARBALL)))

libroot_$(VERSION).deb: changelog
	cd root && dpkg-buildpackage -uc -us -b

changelog: root/debian
	sed -i s/@VERSION@/$(VERSION)/ root/debian/changelog
	
clean:
	-rm -r root

root/debian: root $(wildcard $(LIBROOT_BASE)/debian/*)
	-rm -r root/debian
	cp -rP $(LIBROOT_BASE)/debian root/
	touch root/debian

root: $(TARBALL)
	tar -xf $(TARBALL)
	-rm -r root/debian

download:
	wget -c ftp://root.cern.ch/root/root_v5.32.00.source.tar.gz
