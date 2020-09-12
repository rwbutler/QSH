prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	mkdir -p "$(bindir)"
	install ".build/release/qsh" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/qsh"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
