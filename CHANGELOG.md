# Changelog

## 0.2.5 - 2026-08-27

- Release 0.2.5.

## 0.2.4 - 2026-08-27

- Release 0.2.4.

## Unreleased

- Footer riferimenti: ripristinato il corpo 6/7.5 pt previsto dal manuale; etichette Responsabile/Compilatore in grassetto e spazi funzionali tra campi resi piu compatti senza alterare il tracking del font.

- Reso modulare il footer della prima pagina: responsabile, compilatore, indirizzo, contatti, CF/P.IVA e dati bancari possono essere mostrati o nascosti singolarmente; aggiunti switch per branding/riferimenti/footer completo.
- L'indirizzo del footer deriva automaticamente dai dati dell'intestazione; CF/P.IVA UNIUD hanno valori predefiniti, mentre ABI/CAB/CIN/c/c sono disponibili ma disattivati per default.
- Allineate le proporzioni del marchio dipartimentale alle unita del manuale: 5,25 u di ingombro/sigillo, 1 u di separazione e 4,8 u per l'acronimo centrato.
- L'altezza del marker (13 mm di default) e ora l'unica misura assoluta; tutte le altre dimensioni scalano automaticamente.
- Alleggerito il font dell'acronimo dipartimentale (Gotham Bold/Medium, Work Sans SemiBold/Bold); il wordmark UNIUD mantiene separatamente il peso Black.
- Repository reso self-contained: il sigillo blu UNIUD e incluso come SVG e PDF.
- Rimossi `install-assets.sh`, `check-assets.sh`, `ASSETS.md` e la configurazione `directory-assets`.
- La versione contratta `UNIUD` viene composta direttamente dal pacchetto.
- Licenza del codice/documentazione cambiata a CC BY-NC 4.0; gli asset UNIUD restano esclusi dalla relicenza.

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
