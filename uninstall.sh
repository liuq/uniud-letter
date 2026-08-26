#!/bin/sh
set -eu
root="$(kpsewhich -var-value=TEXMFHOME)"
rm -rf "$root/tex/latex/uniudletter"
rm -rf "$root/doc/latex/uniudletter"
mktexlsr "$root" >/dev/null 2>&1 || true
echo "uniudletter removed from $root"
