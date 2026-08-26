# Changelog

## 0.2.3 - 2026-08-26

- Release 0.2.3.

## 0.2.2 - 2026-08-26

- Release 0.2.2.

## 0.2.0 - 2026-08-26

- Reworked the template against the 2026 UNIUD visual identity manual and the official digital/analog Word templates.
- Added the `uniudletter` class and high-level key/value API.
- Added digital and analog document modes.
- Added institutional and department letterheads.
- Added built-in department mappings for DIUM, DILL, DMIF, DPIA, DIES, DISG, DI4A and DMED.
- Department mark is generated from the official seal plus the department acronym, normalized to 13 mm height.
- Font fallback order for department acronym: Gotham Black, Work Sans Black, Work Sans ExtraBold/emboldened, Helvetica-like, generic sans bold.
- Removed all UNIUD trademark/branding image files from the distributable package.
- Added external asset installation workflow (`install-assets.sh`, `check-assets.sh`).
- Runtime graphics are normalized to PDF; SVG/EPS/PNG are converted once at install time.
- Added convenience import from the official 2025/2026 `*intestata*.dotx` template.
- Added `\UniudAssetsPath{...}` and `directory-assets=...` for project-local PDF assets.
- Added TDS installation support, `l3build` configuration, regression tests, and GitHub Actions CI/release workflow templates.
