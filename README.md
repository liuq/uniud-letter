# uniudletter

Classe LaTeX per lettere dell'Universita degli Studi di Udine, basata su
KOMA-Script (`scrlttr2`) e aggiornata ai modelli ufficiali 2025/2026.

Versione corrente: **0.2.3** (2026-08-26).

## Principio di distribuzione

Il repository distribuisce **solo codice e documentazione**. Sigillo, loghi,
carta intestata e altri asset di identita visiva UNIUD non sono inclusi e vanno
ottenuti separatamente da una fonte autorizzata.

L'installazione degli asset e automatizzata: SVG/PDF/EPS/PNG vengono
normalizzati a PDF una sola volta, senza richiedere conversioni durante la
compilazione LaTeX.

Vedi [ASSETS.md](ASSETS.md).

## Installazione rapida

```sh
./install.sh
./install-assets.sh /percorso/agli/asset-ufficiali
./check-assets.sh
```

`install-assets.sh` accetta anche una directory/ZIP con il modello Word
ufficiale `*intestata*.dotx` e `uniud-sigillo-completo.svg` (o PDF/EPS/PNG):
estrae automaticamente la grafica della carta intestata 2025/2026 e la
converte in PDF per l'uso runtime.

## Uso rapido

```latex
\documentclass{uniudletter}
\usepackage{polyglossia}
\setmainlanguage{italian}

\UniudDipartimento{DPIA}
\UniudDigitale

\UniudSetup{
  indirizzo = {via delle Scienze 206},
  cap = 33100,
  citta = Udine,
  provincia = UD,
  paese = Italia,
  telefono = {+39 0432 558400},
  email = {dpia@uniud.it},
  sito = {uniud.it},
  firmatario = {Nome Cognome},
  ruolo = {Direttore del Dipartimento}
}

\UniudDestinatario{
  nome = {Prof.ssa Nome Cognome},
  struttura = {Universita di Esempio},
  indirizzo = {via Esempio 1},
  cap = 00100,
  citta = Roma
}

\UniudOggetto{Oggetto della comunicazione}

\begin{document}
\begin{letter}{}
\opening{}
Testo della lettera.
\UniudFirma
\end{letter}
\end{document}
```

L'API pubblica evita l'uso diretto delle `komavar`; `\setkomavar` resta un
dettaglio del backend KOMA-Script.

## API

`\UniudSetup{...}` accetta fra le altre le chiavi:

- `documento = digitale | analogico`;
- `intestazione = istituzionale | dipartimento`;
- `acronimo`, `struttura`, `luogo`;
- `indirizzo`, `cap`, `citta`, `provincia`, `paese`, `localita`;
- `telefono`, `fax`, `email`, `sito`;
- `firmatario`, `ruolo`;
- `responsabile`, `compilatore`;
- `protocollo`, `titolo`, `classe`, `fascicolo`;
- `directory-assets` per una directory locale contenente i PDF canonici.

Comandi di comodo:

```latex
\UniudDigitale
\UniudAnalogico
\UniudIstituzionale
\UniudDipartimento{DPIA}
\UniudOggetto{...}
\UniudFirma
\UniudAssetsPath{/percorso/asset-pdf}
```

## Dipartimenti

Sono riconosciuti direttamente:

`DIUM`, `DILL`, `DMIF`, `DPIA`, `DIES`, `DISG`, `DI4A`, `DMED`.

`DEIS` e accettato come alias per `DIES`; la chiave e case-insensitive.

Il marchio di dipartimento viene costruito a runtime da sigillo + acronimo,
entrambi normalizzati a **13 mm di altezza**. Il sigillo e un asset esterno;
l'acronimo usa la catena di font:

1. Gotham Black;
2. Work Sans Black;
3. Work Sans ExtraBold;
4. Work Sans con `FakeBold`;
5. Helvetica Neue Black/Bold o equivalente Helvetica-like;
6. sans-serif bold generico.

I blocchi informativi superiori seguono Circular Bold/Book 8/8 pt; Work Sans e
il fallback quando Circular non e disponibile.

## Uso avanzato

```latex
\documentclass{scrlttr2}
\usepackage{uniudletter}
```

## Motore TeX

Usare **XeLaTeX** (motore verificato dai test). Il codice usa `fontspec`, quindi
pdfLaTeX non e supportato. LuaLaTeX puo funzionare ma non e ancora il motore di
regressione principale.

La grafica usa TikZ con `remember picture`: compilare due volte quando cambia
l'impaginazione.

## Sviluppo e release

```sh
l3build check
l3build ctan
```

`make examples` richiede asset installati e viene mantenuto come test grafico
locale, non come requisito della CI pubblica.

## CTAN e licenze

Il codice e distribuito con licenza MIT. Gli archivi CTAN/TDS non contengono
asset UNIUD. Nome, sigillo, loghi e identita visiva restano proprieta
dell'Universita degli Studi di Udine; vedere `NOTICE`.

## Versioning and releases

`VERSION` is the **single source of truth** for the package version.
`uniudletter-version.tex` is generated from it and is consumed by the class,
package and KOMA letter option; do not edit the generated file manually.
`build.lua` also reads `VERSION` directly for CTAN metadata.

Use `release.sh` to advance the version, regenerate derived metadata, run the
regression tests, create the commit/tag and push the release. For example:

```sh
./release.sh patch
```

A release is triggered **only** when a tag matching `vX.Y.Z` is pushed. The
single workflow `.github/workflows/release.yml` verifies that the tag matches
`VERSION`, runs `l3build check`, builds CTAN/TDS archives, computes SHA-256
checksums and creates the GitHub Release.

GitHub supplies `Source code (zip)` and `Source code (tar.gz)` automatically.
The workflow adds only the derived artifacts:

```text
uniudletter-X.Y.Z-ctan.zip
uniudletter-X.Y.Z.tds.zip
SHA256SUMS
```

Branding assets are deliberately excluded from all of these archives.
