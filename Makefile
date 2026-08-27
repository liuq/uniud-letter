.PHONY: check examples ctan clean install uninstall

EXAMPLES = \
	uniud-example-digital \
	uniud-example-analog \
	uniud-example-dipartimento

check:
	l3build check

# Build the documentation examples. Auxiliary files stay under build/examples,
# while the final PDFs are copied next to their .tex sources so GitHub can
# render/link them directly from the repository.
examples:
	mkdir -p build/examples
	@set -e; \
	for example in $(EXAMPLES); do \
		latexmk -xelatex -interaction=nonstopmode -halt-on-error \
			-outdir=build/examples examples/$$example.tex; \
		cp build/examples/$$example.pdf examples/$$example.pdf; \
	done

ctan:
	l3build ctan

clean:
	l3build clean
	rm -rf build/examples

install:
	./install.sh

uninstall:
	./uninstall.sh
