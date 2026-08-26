#!/bin/sh
set -eu

usage() {
  echo "Usage: ./check-assets.sh [--texmf DIR]" >&2
}

texmf=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --texmf)
      [ "$#" -ge 2 ] || { usage; exit 2; }
      texmf=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

if [ -z "$texmf" ]; then
  texmf=$(kpsewhich -var-value=TEXMFHOME)
fi

dest="$texmf/tex/latex/uniudletter-assets"
status=0
for stem in \
  uniud-letterhead-first \
  uniud-letterhead-first-dipartimento \
  uniud-letterhead-next \
  uniud-sigillo-completo
do
  file="$dest/$stem.pdf"
  if [ -f "$file" ]; then
    echo "OK  $file"
  else
    echo "MISSING  $file" >&2
    status=1
  fi
done
exit "$status"
