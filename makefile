PROJECT := gpodder-ui-qml
VERSION := 4.0.1

all:
	@echo ""
	@echo "  make release ..... Build source release"
	@echo ""

release: dist/$(PROJECT)-$(VERSION).tar.gz

dist/$(PROJECT)-$(VERSION).tar.gz:
	mkdir -p dist
	git archive --format=tar --prefix=$(PROJECT)-$(VERSION)/ $(VERSION) | gzip >$@

clean:
	find . -name '__pycache__' -exec rm {} +

distclean: clean
	rm -rf dist

.PHONY: all release clean
