.PHONY: check examples ctan clean install install-assets check-assets uninstall

check:
	l3build check

examples: check-assets
	mkdir -p build/examples
	for f in examples/*.tex; do \
	  name=$$(basename $$f .tex); \
	  xelatex -interaction=nonstopmode -halt-on-error -output-directory=build/examples $$f; \
	  xelatex -interaction=nonstopmode -halt-on-error -output-directory=build/examples $$f; \
	done

ctan: check
	l3build ctan

clean:
	l3build clean
	rm -rf build/examples

install:
	l3build install

install-assets:
	@test -n "$(ASSETS)" || { echo "Usage: make install-assets ASSETS=/path/to/assets" >&2; exit 2; }
	./install-assets.sh "$(ASSETS)"

check-assets:
	./check-assets.sh

uninstall:
	@root=$$(kpsewhich -var-value=TEXMFHOME); \
	 echo "Removing $$root/tex/latex/uniudletter"; \
	 rm -rf "$$root/tex/latex/uniudletter"; \
	 rm -rf "$$root/doc/latex/uniudletter"; \
	 mktexlsr "$$root" >/dev/null 2>&1 || true
