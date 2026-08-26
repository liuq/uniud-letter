#!/usr/bin/env bash

set -euo pipefail

die() {
    echo "ERROR: $*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage:
  ./release.sh patch
  ./release.sh minor
  ./release.sh major
  ./release.sh X.Y.Z
  ./release.sh vX.Y.Z

Examples:
  ./release.sh patch      # 0.2.1 -> 0.2.2
  ./release.sh minor      # 0.2.1 -> 0.3.0
  ./release.sh major      # 0.2.1 -> 1.0.0
  ./release.sh 0.2.2
EOF
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

        if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            usage
        fi
        ;;
esac

NEW_TAG="v${NEW_VERSION}"

if [[ "$NEW_VERSION" == "$OLD_VERSION" ]]; then
    die "New version is identical to current version"
fi

echo
echo "uniudletter release"
echo "-------------------"
echo "Current version : $OLD_VERSION"
echo "New version     : $NEW_VERSION"
echo "Tag             : $NEW_TAG"
echo

#
# Require a clean tree.
#
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean:"
    git status --short
    echo
    die "Commit or stash changes before releasing"
fi

#
# Refresh remote information before checking tags.
#
echo "Refreshing remote tags..."
git fetch --tags --prune origin

#
# Never overwrite an existing release tag.
#
if git rev-parse -q --verify "refs/tags/$NEW_TAG" >/dev/null; then
    die "Local tag '$NEW_TAG' already exists"
fi

if git ls-remote --exit-code --tags origin "refs/tags/$NEW_TAG" \
    >/dev/null 2>&1; then
    die "Remote tag '$NEW_TAG' already exists"
fi

#
# Files whose current package version should remain synchronized.
#
FILES=(
    README.md
    INSTALL.md
    ASSETS.md
    build.lua
)

while IFS= read -r file; do
    FILES+=("$file")
done < <(
    find . -type f \
        \( -name '*.cls' -o -name '*.sty' -o -name '*.lco' \) \
        -not -path './build/*' \
        -not -path './.git/*' \
        -print |
    sed 's#^\./##' |
    sort
)

echo
echo "Updating package version..."

printf '%s\n' "$NEW_VERSION" > VERSION

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || continue

    if grep -Fq "$OLD_VERSION" "$file"; then
        echo "  $file"

        OLD="$OLD_VERSION" NEW="$NEW_VERSION" \
            perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' "$file"
    fi
done

#
# Add a CHANGELOG entry without replacing historical versions.
#
if [[ -f CHANGELOG.md ]]; then
    TODAY="$(date +%Y-%m-%d)"

    if ! grep -Eq "^## .*${NEW_VERSION}" CHANGELOG.md; then
        echo "  CHANGELOG.md"

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

#
# Check whether the old version survived somewhere it should not.
#
echo
echo "Checking for stale version references..."

STALE="$(
    git grep -n -F "$OLD_VERSION" -- \
        README.md \
        INSTALL.md \
        ASSETS.md \
        build.lua \
        '*.cls' \
        '*.sty' \
        '*.lco' \
        2>/dev/null || true
)"

if [[ -n "$STALE" ]]; then
    echo
    echo "Old version still found:"
    echo "$STALE"
    echo
    die "Version synchronization incomplete"
fi

#
# Run the package tests before committing anything.
#
command -v l3build >/dev/null 2>&1 \
    || die "l3build not found"

echo
echo "Running l3build check..."
l3build check

#
# Show the release diff.
#
echo
echo "Changes:"
echo

git status --short
echo
git diff -- VERSION README.md INSTALL.md ASSETS.md build.lua \
    CHANGELOG.md '*.cls' '*.sty' '*.lco' 2>/dev/null || true

echo
read -r -p "Create and push release $NEW_TAG? [y/N] " answer

case "$answer" in
    y|Y|yes|YES)
        ;;
    *)
        echo "Release cancelled."
        echo "Version changes remain in the working tree."
        exit 0
        ;;
esac

#
# Commit all release metadata.
#
git add VERSION

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] && git add "$file"
done

[[ -f CHANGELOG.md ]] && git add CHANGELOG.md

git commit -m "Release $NEW_TAG"

#
# Create annotated release tag.
#
git tag -a "$NEW_TAG" -m "uniudletter $NEW_VERSION"

CURRENT_BRANCH="$(git branch --show-current)"

[[ -n "$CURRENT_BRANCH" ]] \
    || die "Cannot determine current branch"

#
# Push the commit first.
#
echo
echo "Pushing branch $CURRENT_BRANCH..."
git push origin "$CURRENT_BRANCH"

#
# Then push the tag.
# This is what triggers the GitHub release action.
#
echo
echo "Pushing tag $NEW_TAG..."
git push origin "$NEW_TAG"

echo
echo "Release $NEW_TAG pushed successfully."
echo "GitHub Actions should now build the CTAN/TDS artifacts."