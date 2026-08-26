#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <version>"
    echo
    echo "Examples:"
    echo "  $0 0.2.2"
    echo "  $0 v0.2.2"
    exit 1
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

[[ $# -eq 1 ]] || usage

# Accept both 0.2.2 and v0.2.2
NEW_VERSION="${1#v}"
NEW_TAG="v${NEW_VERSION}"

# Basic semantic-version validation
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    die "Invalid version '$1'. Expected X.Y.Z or vX.Y.Z"
fi

# Must be run from repository root
[[ -d .git ]] || die "Run this script from the repository root"
[[ -f VERSION ]] || die "VERSION file not found"

OLD_VERSION="$(tr -d '[:space:]' < VERSION)"

if [[ ! "$OLD_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    die "Current VERSION file contains an invalid version: '$OLD_VERSION'"
fi

if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    die "VERSION is already $NEW_VERSION"
fi

echo "Preparing release:"
echo "  $OLD_VERSION -> $NEW_VERSION"
echo "  tag: $NEW_TAG"
echo

# Do not overwrite an existing local tag
if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
    die "Local tag '$NEW_TAG' already exists"
fi

# Do not overwrite an existing remote tag
if git ls-remote --exit-code --tags origin "refs/tags/$NEW_TAG" \
    >/dev/null 2>&1; then
    die "Remote tag '$NEW_TAG' already exists"
fi

# Require a clean working tree before we modify anything.
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean:"
    git status --short
    echo
    die "Commit or stash your changes before making a release"
fi

#
# Files in which the current package version is metadata and should
# therefore be kept synchronized.
#
FILES=(
    README.md
    INSTALL.md
    ASSETS.md
    build.lua
)

# Add LaTeX implementation files automatically.
while IFS= read -r file; do
    FILES+=("$file")
done < <(
    find . -maxdepth 3 -type f \
        \( -name '*.cls' -o -name '*.sty' -o -name '*.lco' \) \
        -print |
    sed 's#^\./##' |
    sort
)

echo "Updating VERSION"
printf '%s\n' "$NEW_VERSION" > VERSION

echo "Updating package metadata"

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || continue

    # Only touch files that actually contain the old version.
    if grep -Fq "$OLD_VERSION" "$file"; then
        echo "  $file"

        # Perl is used instead of sed -i because the latter behaves
        # differently on GNU/Linux and macOS.
        OLD="$OLD_VERSION" NEW="$NEW_VERSION" \
        perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' "$file"
    fi
done

echo
echo "Checking for stale occurrences of $OLD_VERSION ..."

STALE="$(
    git grep -n -F "$OLD_VERSION" -- \
        ':!CHANGELOG.md' \
        ':!release.sh' \
        2>/dev/null || true
)"

if [[ -n "$STALE" ]]; then
    echo
    echo "The old version still occurs in tracked files:"
    echo
    echo "$STALE"
    echo
    die "Review these occurrences before releasing"
fi

echo "Version metadata synchronized."

#
# Regression tests
#
if command -v l3build >/dev/null 2>&1; then
    echo
    echo "Running l3build check ..."
    l3build check
else
    die "l3build not found; refusing to create the release"
fi

#
# Show exactly what will be committed.
#
echo
echo "Changes for release $NEW_TAG:"
git diff -- VERSION "${FILES[@]}" 2>/dev/null || true

echo
git status --short
echo

#
# Commit
#
git add VERSION

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] && git add "$file"
done

git commit -m "Release $NEW_TAG"

#
# Tag
#
git tag -a "$NEW_TAG" -m "uniudletter $NEW_VERSION"

#
# Push commit first, then tag.
# The tag push triggers .github/workflows/release.yml.
#
CURRENT_BRANCH="$(git branch --show-current)"

[[ -n "$CURRENT_BRANCH" ]] || die "Cannot determine current branch"

echo
echo "Pushing branch '$CURRENT_BRANCH' ..."
git push origin "$CURRENT_BRANCH"

echo
echo "Pushing tag '$NEW_TAG' ..."
git push origin "$NEW_TAG"

echo
echo "Release $NEW_TAG pushed successfully."
echo "GitHub Actions should now build and publish the release."