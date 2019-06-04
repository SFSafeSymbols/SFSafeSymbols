SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: symbolenumcreator

symbolenumcreator: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: symbolenumcreator
	@install -d "$(bindir)" "$(libdir)"
	@install "$(BUILDDIR)/release/symbolenumcreator" "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/symbolenumcreator"

.PHONY: clean
distclean:
	@rm -f $(BUILDDIR)/release

.PHONY: clean
clean: distclean
	@rm -rf $(BUILDDIR)