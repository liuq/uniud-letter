# uniudletter

Classe LaTeX per lettere dell'Universita degli Studi di Udine, basata su
KOMA-Script (`scrlttr2`) e aggiornata ai modelli ufficiali 2025/2026.

Versione corrente: **0.2.3** (2026-08-26).

## Repository self-contained

Il repository contiene tutto cio che serve a compilare una lettera, incluso il
sigillo UNIUD blu usato nell'intestazione. Non e piu necessaria una procedura
separata di installazione degli asset.

Sono inclusi:

- `uniud-sigillo-blu.svg` e `uniud-sigillo-blu.pdf`: il solo sigillo blu;
- `uniud-footer-istituzionale-blu.svg` e relativo PDF runtime: il blocco
  `UNIVERSITA DEGLI STUDI DI UDINE / HIC SUNT FUTURA`;
- `uniud-footer-certificazioni.pdf`: i marchi HR e certificazione qualita'.

Il marchio contratto `UNI/UD` delle pagine successive non e' un asset: viene
composto tipograficamente dalla classe.

Il crop deriva dal file ufficiale blu `versione_01` disponibile alla data
2026-08-26. I file ufficiali dell'identita visiva possono essere scaricati da:

https://www.uniud.it/uniud/it/ateneo-uniud/identita-visiva/manuale_dimmagine/files

Se l'Ateneo aggiorna l'identita visiva o i file sorgente, prevalgono sempre i
materiali istituzionali correnti. Provenienza e diritti del sigillo sono
specificati in `NOTICE`.

## Installazione rapida

Dalla radice del repository:

```sh
l3build install
```

oppure:

```sh
./install.sh
```

Verifica, da una directory diversa dal repository:

```sh
kpsewhich uniudletter.cls
kpsewhich uniud-sigillo-blu.pdf
```

## Uso rapido

```latex
\documentclass{uniudletter}
\usepackage{polyglossia}
\setmainlanguage{italian}

\UniudDipartimento{DPIA}

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

## Esempi come documentazione

I tre file in `examples/` sono esempi compilabili e, allo stesso tempo, una
documentazione commentata dei tre casi d'uso principali:

- [lettera istituzionale digitale (PDF)](examples/uniud-example-digital.pdf) - [sorgente `.tex`](examples/uniud-example-digital.tex);
- [lettera istituzionale analogica (PDF)](examples/uniud-example-analog.pdf) - [sorgente `.tex`](examples/uniud-example-analog.tex);
- [lettera di dipartimento (PDF)](examples/uniud-example-dipartimento.pdf) - [sorgente `.tex`](examples/uniud-example-dipartimento.tex). Per la variante analogica basta usare `\UniudAnalogico` e, se necessario, `\UniudProtocollo`.

I PDF sono versionati insieme ai sorgenti e vengono rigenerati automaticamente
da `release.sh` prima di creare il commit/tag di release. La GitHub Action li
ricompila a sua volta e li allega anche agli asset della release.

I contatti del mittente sono campi nativi di `\UniudSetup`: `telefono`, `fax`,
`email` e `sito`. Nelle lettere di dipartimento il footer personale e' minimale:
i contatti vengono riportati nel pie' di pagina solo se si abilita il blocco
`footer-contatti`. Nelle lettere istituzionali questo blocco e' attivo per
default. `responsabile` e `compilatore` formano un unico blocco automatico e
devono essere specificati insieme.

## API

`\UniudSetup{...}` accetta fra le altre le chiavi:

- `documento = normale | digitale | analogico`;
- `intestazione = istituzionale | dipartimento`;
- `acronimo`, `struttura`, `luogo`;
- `indirizzo`, `cap`, `citta`, `provincia`, `paese`, `localita`;
- `telefono`, `fax`, `email`, `sito`;
- `firmatario`, `ruolo`;
- `responsabile`, `compilatore`;
- `codice-fiscale`, `partita-iva`, `abi`, `cab`, `cin`, `conto-corrente`;
- `footer-responsabili = auto | true | false`;
- `footer-contatti = true | false`;
- `footer-fiscale = true | false`;
- `footer-prima-pagina`, `footer-marchio`, `footer-certificazioni`;
- `protocollo`, `titolo`, `classe`, `fascicolo`.

Comandi di comodo:

```latex
\UniudNormale
\UniudDigitale
\UniudAnalogico
\UniudIstituzionale
\UniudDipartimento{DPIA}
\UniudOggetto{...}
\UniudFirma
```

## Dipartimenti

Sono riconosciuti direttamente:

`DIUM`, `DILL`, `DMIF`, `DPIA`, `DIES`, `DISG`, `DI4A`, `DMED`.

La chiave e case-insensitive.

Il marchio di dipartimento viene costruito a runtime dal sigillo incluso e
dall'acronimo secondo le proporzioni del manuale. L'ingombro verticale del
marker e l'unica misura assoluta (di default **13 mm = 5,25 u**); tutte le altre
misure derivano da questa unita: sigillo **5,25 u**, separazione **1 u**,
acronimo **4,8 u** centrato verticalmente nel marker. Cambiando l'altezza del
marker, l'intero marchio scala mantenendo le stesse proporzioni.

Per l'acronimo dipartimentale la catena di font privilegia un peso meno pesante
del wordmark UNIUD: Gotham Bold/Medium, Work Sans SemiBold/Bold, quindi
Helvetica-like e infine sans-serif bold generico. Il wordmark contratto `UNIUD`
resta invece in Gotham Black, con Work Sans Black come fallback principale.

I blocchi informativi superiori seguono Circular Bold/Book 8/8 pt; Work Sans e
il fallback previsto per applicazioni d'ufficio quando Circular non e
disponibile.

La versione contratta `UNIUD` dell'intestazione istituzionale e delle pagine
successive viene composta direttamente dal pacchetto con la stessa catena
tipografica; non richiede un secondo file grafico.

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

## Sviluppo

```sh
l3build check
make examples
l3build ctan
```

## Licenza

Il codice e la documentazione originali del progetto sono distribuiti con
**Creative Commons Attribution-NonCommercial 4.0 International
(CC BY-NC 4.0)**. CTAN classifica questa licenza come non-free per via della
clausola NonCommercial.

Il nome, il sigillo e gli altri elementi dell'identita visiva UNIUD **non sono
relicenziati** sotto CC BY-NC 4.0 e restano soggetti ai diritti e alle regole
d'uso dell'Universita degli Studi di Udine. Vedere `LICENSE` e `NOTICE`.

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
The workflow adds:

```text
uniudletter-X.Y.Z-ctan.zip
uniudletter-X.Y.Z.tds.zip
SHA256SUMS
```

### Modalita', protocollo e footer

La modalita' documentale predefinita e' `normale`: `\UniudFirma` non aggiunge
nessuna dicitura automatica sulla firma. `\UniudDigitale` abilita esplicitamente
la dicitura relativa alla firma digitale; `\UniudAnalogico` seleziona il modello
con i campi tradizionali. `\UniudNormale` ripristina esplicitamente il default.

Nelle lettere di dipartimento `\UniudProtocollo{...}` e' facoltativo: se non
viene impostato, il blocco protocollo/riferimenti non viene stampato e non viene
riservato spazio. Anche in modalita' normale una lettera istituzionale non mostra
il blocco se nessun campo e' stato fornito.

Il footer della prima pagina mantiene per default il **branding UNIUD** a
sinistra e le **certificazioni** a destra. I dati variabili centrali sono
organizzati in soli tre blocchi:

- `footer-responsabili = auto | true | false`: gestisce insieme responsabile e
  compilatore. Con `auto` (default), il blocco compare se entrambi sono
  valorizzati; se ne viene fornito uno solo la compilazione segnala un errore.
  `false` sopprime intenzionalmente il blocco e il controllo;
- `footer-contatti = true | false`: gestisce insieme indirizzo, telefono, fax,
  e-mail e sito. I campi vuoti sono omessi senza lasciare separatori;
- `footer-fiscale = true | false`: gestisce insieme CF, P.IVA ed eventuali ABI,
  CAB, CIN e conto corrente.

Il profilo dipende dal tipo di intestazione. Una lettera di **dipartimento** e'
pensata come lettera personale: `footer-contatti=false` e
`footer-fiscale=false` per default. Una lettera **istituzionale** attiva invece
entrambi i blocchi. Il blocco responsabile/compilatore resta `auto` in entrambi
i casi.

Esempio, per arricchire una lettera personale di dipartimento:

```latex
\UniudSetup{
  responsabile = {Nome Cognome - nome.cognome@uniud.it},
  compilatore  = {Nome Cognome - nome.cognome@uniud.it},
  footer-contatti = true,
  footer-fiscale = true,
  abi = {02008},
  cab = {12310}
}
```

L'indirizzo del footer non va duplicato: il blocco contatti lo costruisce
automaticamente dalle stesse chiavi `indirizzo`, `cap`, `citta`, `provincia` e
`paese` usate nell'intestazione. CF e P.IVA hanno valori istituzionali
predefiniti; i dati fiscali/bancari possono essere sostituiti con
`codice-fiscale`, `partita-iva`, `abi`, `cab`, `cin` e `conto-corrente`.

Per eliminare completamente il footer della prima pagina si puo' usare:

```latex
\UniudSetup{footer-prima-pagina=false}
```

`footer-marchio` e `footer-certificazioni` restano disponibili come controlli
avanzati, ma il loro default e' sempre `true`. Una nota libera aggiuntiva puo'
essere inserita con `pie-prima-pagina`.

Dalla seconda pagina il logo contratto `UNI/UD` viene impaginato a 12 mm dai
bordi superiore e sinistro, con larghezza 21,3 mm; la numerazione usa il formato
`2 di X`.
