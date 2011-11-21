#!/usr/bin/make -f

LIBROOT_MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))
LIBROOT_BASE?=$(dir $(LIBROOT_MAKEFILE))

TARBALL?=$(shell ls -l root_v*.source.tar.gz|tail -n 1)
VERSION?=$(patsubst root_v%.source.tar.gz,%,$(notdir $(TARBALL)))

build: changelog
	cd root && dpkg-buildpackage -uc -us -b

changelog: replace
	sed -i s/@VERSION@/$(VERSION)/ root/debian/changelog
	
clean:
	-rm -r root

replace: root $(wildcard $(LIBROOT_BASE)/debian/*)
	-rm -r root/debian
	cp -rP $(LIBROOT_BASE)/debian root/

root: $(TARBALL)
	tar -xf $(TARBALL)



	


