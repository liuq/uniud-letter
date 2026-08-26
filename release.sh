#!/usr/bin/env bash

set -euo pipefail

die() {
    echo "ERROR: $*" >&2
    exit 1
}

usage() {
    cat <<'USAGE'
Usage:
  ./release.sh patch
  ./release.sh minor
  ./release.sh major
  ./release.sh X.Y.Z
  ./release.sh vX.Y.Z
USAGE
    exit 1
}

[[ $# -eq 1 ]] || usage
[[ -d .git ]] || die "Run this script from the repository root"
[[ -f VERSION ]] || die "VERSION file not found"

OLD_VERSION="$(tr -d '[:space:]' < VERSION)"

if [[ ! "$OLD_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    die "Invalid current VERSION: '$OLD_VERSION'"
fi

MAJOR="${BASH_REMATCH[1]}"
MINOR="${BASH_REMATCH[2]}"
PATCH="${BASH_REMATCH[3]}"

case "$1" in
    patch)
        NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
        ;;
    minor)
        NEW_VERSION="${MAJOR}.$((MINOR + 1)).0"
        ;;
    major)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        ;;
    *)
        NEW_VERSION="${1#v}"
        [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || usage
        ;;
esac

NEW_TAG="v${NEW_VERSION}"

echo
echo "uniudletter release"
echo "-------------------"
echo "Current version : $OLD_VERSION"
echo "New version     : $NEW_VERSION"
echo "Tag             : $NEW_TAG"
echo

if [[ -n "$(git status --porcelain)" ]]; then
    git status --short
    die "Working tree is not clean"
fi

git fetch --tags --prune origin

if git rev-parse -q --verify "refs/tags/$NEW_TAG" >/dev/null; then
    die "Local tag '$NEW_TAG' already exists"
fi

if git ls-remote --exit-code --tags origin "refs/tags/$NEW_TAG" >/dev/null 2>&1; then
    die "Remote tag '$NEW_TAG' already exists"
fi

# VERSION is the only source of truth.
printf '%s\n' "$NEW_VERSION" > VERSION

# Generate the TeX-facing version file from VERSION.
cat > uniudletter-version.tex <<TEXVERSION
% This file is generated from VERSION.
% Do not edit manually.
\\def\\UniudLetterVersion{$NEW_VERSION}
TEXVERSION

# README contains release examples and a human-readable current-version line.
# They are derived from VERSION; do not edit their version numbers manually.
if [[ -f README.md ]]; then
    OLD="$OLD_VERSION" NEW="$NEW_VERSION" perl -0pi -e '
      s/Versione corrente: \*\*\Q$ENV{OLD}\E\*\*/Versione corrente: **$ENV{NEW}**/g;
      s/\bv\Q$ENV{OLD}\E\b/v$ENV{NEW}/g;
      s/uniudletter-\Q$ENV{OLD}\E(-ctan\.zip|\.tds\.zip)/uniudletter-$ENV{NEW}$1/g;
    ' README.md
fi

# Add a changelog entry; historical version entries are intentionally preserved.
if [[ -f CHANGELOG.md ]]; then
    TODAY="$(date +%Y-%m-%d)"
    if ! grep -Eq "^## ${NEW_VERSION}([[:space:]]|$)" CHANGELOG.md; then
        TMPFILE="$(mktemp)"
        {
            IFS= read -r first_line || true
            printf '%s\n' "$first_line"
            printf '\n## %s - %s\n\n' "$NEW_VERSION" "$TODAY"
            printf '%s\n' "- Release ${NEW_VERSION}."
            cat
        } < CHANGELOG.md > "$TMPFILE"
        mv "$TMPFILE" CHANGELOG.md
    fi
fi

# The implementation files must not contain a hard-coded semantic version.
if grep -En '[vV]?[0-9]+\.[0-9]+\.[0-9]+' uniudletter.cls uniudletter.sty uniud.lco 2>/dev/null; then
    die "Hard-coded version found in LaTeX implementation; use \\UniudLetterVersion instead"
fi

command -v l3build >/dev/null 2>&1 || die "l3build not found"

echo
echo "Running l3build check..."
l3build check

echo
echo "Changes:"
git status --short
echo
git diff -- VERSION uniudletter-version.tex README.md CHANGELOG.md || true

echo
read -r -p "Create and push release $NEW_TAG? [y/N] " answer
case "$answer" in
    y|Y|yes|YES) ;;
    *)
        echo "Release cancelled. Generated changes remain in the working tree."
        exit 0
        ;;
esac

git add VERSION uniudletter-version.tex README.md
[[ -f CHANGELOG.md ]] && git add CHANGELOG.md

git commit -m "Release $NEW_TAG"
git tag -a "$NEW_TAG" -m "uniudletter $NEW_VERSION"

CURRENT_BRANCH="$(git branch --show-current)"
[[ -n "$CURRENT_BRANCH" ]] || die "Cannot determine current branch"

git push origin "$CURRENT_BRANCH"
git push origin "$NEW_TAG"

echo
echo "Release $NEW_TAG pushed successfully."
