PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
DESTDIR ?=

.PHONY: all install uninstall deb clean test

all:
	@echo "Nothing to compile (Python). Run 'make install' or 'make deb'."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 bin/ea-fix $(DESTDIR)$(BINDIR)/ea-fix

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/ea-fix

deb:
	./build-deb.sh

test:
	python3 -m py_compile bin/ea-fix
	./bin/ea-fix status

clean:
	rm -rf build dist __pycache__ bin/__pycache__
