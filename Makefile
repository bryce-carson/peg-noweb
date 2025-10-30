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

## TODO: makem.sh is suposed to be easier than what I'm doing... read the documentation carefully!
test-interactive: tangle
	emacs --quick --eval="(when (and (load-library \"peg\") (load \"$(BUILD)/peg-noweb-0.1/peg-noweb.el\") (find-file \"$(TEST)/test.el\") (eval-buffer)))"

weave:
	mkdir -p $(BUILD)
	# noweave -delay -autodefs elisp -index $(SRC)/peg-noweb.nw > $(BUILD)/peg-noweb.tex
	noweave -delay $(SRC)/peg-noweb.nw > $(BUILD)/peg-noweb.tex
	cd $(BUILD) && latexmk --xelatex --interaction=nonstopmode -f peg-noweb.tex
