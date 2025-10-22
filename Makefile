VERSION := 0.1
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BUILD ?= ${ROOT_DIR}build
SRC ?= ${ROOT_DIR}src
TEST ?= ${ROOT_DIR}test

# Allow NOWEB_LIB to be overridden (e.g., via command line or Docker)
NOWEB_LIB ?= /usr/local/noweb/lib
markup ?= ${NOWEB_LIB}/markup
finduses ?= ${NOWEB_LIB}/finduses
noidx ?= ${NOWEB_LIB}/noidx
autodefs_elisp ?= ${NOWEB_LIB}/autodefs.elisp

# TODO: create a TODO.org file (once I learn how they work) and create a README
# for the project within that.
# readme:
# 	emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "TODO.org")'

clean:
	$(RM) --recursive --force $(BUILD)

tangle: clean
	mkdir -p $(BUILD)
	notangle -Rpeg-noweb.el $(SRC)/peg-noweb.nw > $(BUILD)/peg-noweb.el
	mkdir -p $(BUILD)/peg-noweb-$(VERSION)
	mv -t $(BUILD)/peg-noweb-$(VERSION) $(BUILD)/peg-noweb.el
	cp -t $(BUILD)/peg-noweb-$(VERSION) LICENSE
	tar --create --file $(BUILD)/peg-noweb-$(VERSION).tar -C $(BUILD) peg-noweb-$(VERSION)
	tar --list --file $(BUILD)/peg-noweb-$(VERSION).tar

# TODO: write some tests. Use a testing framework?
# test: clean tangle
# 	mkdir -p $(TEST)
# 	notangle -Rexample-test-name.el $(SRC)/peg-noweb.nw > $(TEST)/example-test-name.el

weave:
	mkdir -p $(BUILD)
	noweave -delay -autodefs elisp -index $(SRC)/peg-noweb.nw > $(BUILD)/peg-noweb.tex
	cd $(BUILD) && latexmk --xelatex --interaction=nonstopmode -f peg-noweb.tex
