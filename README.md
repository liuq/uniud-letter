# uniudletter

Classe LaTeX per lettere dell'Universita degli Studi di Udine, basata su
KOMA-Script (`scrlttr2`) e aggiornata ai modelli ufficiali 2025/2026.

Versione corrente: **0.2.0** (2026-08-26).

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

## Continuous integration and releases

The repository includes two GitHub Actions workflows:

- `.github/workflows/ci.yml` runs `l3build check`, tests installation of external branding assets using synthetic PDFs, and verifies that the CTAN/TDS archives can be built. The generated archives are retained as temporary workflow artifacts.
- `.github/workflows/release.yml` runs for tags matching `vX.Y.Z` (or manually for an existing tag), verifies that `VERSION` matches the tag, runs the test suite, builds the CTAN and TDS archives, creates SHA-256 checksums, and attaches the versioned files to the GitHub Release.

A normal release therefore only requires committing the source tree and tagging it:

```sh
git tag v0.2.0
git push origin v0.2.0
```

GitHub itself supplies the automatically generated `Source code (zip)` and `Source code (tar.gz)` archives. The workflow adds only the derived release artifacts:

```text
uniudletter-0.2.0-ctan.zip
uniudletter-0.2.0.tds.zip
SHA256SUMS
```

Branding assets are deliberately excluded from all of these archives.
