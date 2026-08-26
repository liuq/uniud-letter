#!/bin/sh
# Install external UNIUD graphic assets into TEXMFHOME as PDF files.
# The package intentionally does not redistribute UNIUD trademarks.
set -eu

usage() {
  cat <<'EOF'
Usage:
  ./install-assets.sh [--texmf DIR] ASSET_SOURCE

ASSET_SOURCE may be a directory or a ZIP archive.

Preferred input: one of .pdf, .svg, .eps or .png for each canonical stem:
  uniud-letterhead-first
  uniud-letterhead-first-dipartimento
  uniud-letterhead-next
  uniud-sigillo-completo

Convenience mode for the official Word template:
  put an official *intestata*.dotx in ASSET_SOURCE together with
  uniud-sigillo-completo.(pdf|svg|eps|png). The installer extracts the
  institutional first/next-page artwork from the DOTX and derives the
  department background automatically.

At runtime uniudletter uses PDF only. SVG/EPS/PNG conversion happens once,
at install time. SVG conversion uses Inkscape (preferred) or rsvg-convert.

Installed location:
  TEXMFHOME/tex/latex/uniudletter-assets/
EOF
}

texmf=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --texmf)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      texmf=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

[ "$#" -eq 1 ] || { usage >&2; exit 2; }
source_arg=$1

if [ -z "$texmf" ]; then
  if command -v kpsewhich >/dev/null 2>&1; then
    texmf=$(kpsewhich -var-value=TEXMFHOME)
  else
    echo "kpsewhich not found; pass --texmf DIR explicitly." >&2
    exit 2
  fi
fi

dest="$texmf/tex/latex/uniudletter-assets"
mkdir -p "$dest"

tmp=$(mktemp -d "${TMPDIR:-/tmp}/uniudletter-assets.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

case "$source_arg" in
  *.zip|*.ZIP)
    command -v unzip >/dev/null 2>&1 || { echo "unzip is required for ZIP input." >&2; exit 2; }
    mkdir -p "$tmp/source"
    unzip -q "$source_arg" -d "$tmp/source"
    srcdir="$tmp/source"
    ;;
  *)
    [ -d "$source_arg" ] || { echo "Asset source not found: $source_arg" >&2; exit 2; }
    srcdir=$source_arg
    ;;
esac

work="$tmp/work"
mkdir -p "$work"

# Search recursively, because official logo bundles often contain nested folders.
find_asset() {
  stem=$1
  for ext in pdf svg SVG eps EPS png PNG; do
    p=$(find "$srcdir" -type f -name "$stem.$ext" -print 2>/dev/null | head -n 1 || true)
    if [ -n "$p" ]; then
      printf '%s\n' "$p"
      return 0
    fi
  done
  return 1
}

# If canonical letterhead artwork is absent, an official DOTX can provide it.
prepare_from_dotx() {
  first=$(find_asset uniud-letterhead-first || true)
  next=$(find_asset uniud-letterhead-next || true)
  dept=$(find_asset uniud-letterhead-first-dipartimento || true)
  if [ -n "$first" ] && [ -n "$next" ] && [ -n "$dept" ]; then
    return 0
  fi

  dotx=$(find "$srcdir" -type f \( -iname '*intestata*.dotx' -o -iname '*.dotx' \) -print 2>/dev/null | head -n 1 || true)
  [ -n "$dotx" ] || return 0
  command -v unzip >/dev/null 2>&1 || { echo "unzip is required to read $dotx" >&2; return 1; }

  dotxdir="$tmp/dotx"
  rm -rf "$dotxdir"
  mkdir -p "$dotxdir"
  unzip -q "$dotx" -d "$dotxdir"

  # The official 2025/2026 templates contain image2.png = A4 first-page artwork
  # and image1.png = continuation-page strip. Validate dimensions before using.
  if [ -f "$dotxdir/word/media/image2.png" ] && [ -z "$first" ]; then
    cp "$dotxdir/word/media/image2.png" "$work/uniud-letterhead-first.png"
  fi
  if [ -f "$dotxdir/word/media/image1.png" ] && [ -z "$next" ]; then
    cp "$dotxdir/word/media/image1.png" "$work/uniud-letterhead-next.png"
  fi

  if [ -z "$dept" ] && [ -f "$dotxdir/word/media/image2.png" ]; then
    # Department letterhead uses the same footer but not the institutional
    # contracted mark, pre-filled right header, or isolated central seal.
    # These coordinates are normalized for the official 2480x3508 A4 artwork.
    if command -v magick >/dev/null 2>&1; then
      magick "$dotxdir/word/media/image2.png" \
        -fill white \
        -draw 'rectangle 120,130 560,490' \
        -draw 'rectangle 1240,130 2360,490' \
        -draw 'rectangle 120,1200 500,1460' \
        "$work/uniud-letterhead-first-dipartimento.png"
    elif command -v convert >/dev/null 2>&1; then
      convert "$dotxdir/word/media/image2.png" \
        -fill white \
        -draw 'rectangle 120,130 560,490' \
        -draw 'rectangle 1240,130 2360,490' \
        -draw 'rectangle 120,1200 500,1460' \
        "$work/uniud-letterhead-first-dipartimento.png"
    else
      echo "DOTX mode needs ImageMagick to derive the department background." >&2
      return 1
    fi
  fi
}

prepare_from_dotx

find_prepared() {
  stem=$1
  for ext in pdf svg SVG eps EPS png PNG; do
    if [ -f "$work/$stem.$ext" ]; then
      printf '%s\n' "$work/$stem.$ext"
      return 0
    fi
  done
  find_asset "$stem"
}

convert_one() {
  stem=$1
  src=$(find_prepared "$stem") || {
    echo "Missing asset: $stem.(pdf|svg|eps|png)" >&2
    return 1
  }
  out="$dest/$stem.pdf"
  case "$src" in
    *.pdf)
      cp "$src" "$out"
      ;;
    *.svg|*.SVG)
      if command -v inkscape >/dev/null 2>&1; then
        inkscape "$src" --export-type=pdf --export-filename="$out" >/dev/null
      elif command -v rsvg-convert >/dev/null 2>&1; then
        rsvg-convert -f pdf -o "$out" "$src"
      else
        echo "Cannot convert $src: install Inkscape or rsvg-convert." >&2
        return 1
      fi
      ;;
    *.eps|*.EPS)
      if command -v epstopdf >/dev/null 2>&1; then
        epstopdf "$src" --outfile="$out"
      else
        echo "Cannot convert $src: epstopdf is required." >&2
        return 1
      fi
      ;;
    *.png|*.PNG)
      if command -v img2pdf >/dev/null 2>&1; then
        img2pdf "$src" -o "$out"
      elif command -v magick >/dev/null 2>&1; then
        magick "$src" "$out"
      elif command -v convert >/dev/null 2>&1; then
        convert "$src" "$out"
      else
        echo "Cannot convert $src: install img2pdf or ImageMagick." >&2
        return 1
      fi
      ;;
  esac
  echo "installed $out"
}

status=0
for stem in \
  uniud-letterhead-first \
  uniud-letterhead-first-dipartimento \
  uniud-letterhead-next \
  uniud-sigillo-completo
do
  convert_one "$stem" || status=1
done

[ "$status" -eq 0 ] || {
  echo "Asset installation incomplete." >&2
  exit 1
}

if command -v mktexlsr >/dev/null 2>&1; then
  mktexlsr "$texmf" >/dev/null 2>&1 || true
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ -x "$script_dir/check-assets.sh" ]; then
  "$script_dir/check-assets.sh" --texmf "$texmf"
fi
