# Asset grafici UNIUD

`uniudletter` **non distribuisce** sigillo, loghi o carta intestata UNIUD.
Il codice e gli asset hanno quindi cicli di distribuzione separati.

## Formato runtime

Il package usa esclusivamente PDF a runtime. Questo evita `--shell-escape` e
rende la compilazione indipendente da Inkscape.

L'installer accetta invece, per ciascun asset, uno fra:

- PDF (copiato senza conversione);
- SVG (convertito in PDF con Inkscape o `rsvg-convert`);
- EPS (convertito con `epstopdf`);
- PNG (fallback raster, convertito in PDF).

## Nomi canonici

Una directory di asset completa puo contenere:

```text
uniud-letterhead-first.svg
uniud-letterhead-first-dipartimento.svg
uniud-letterhead-next.svg
uniud-sigillo-completo.svg
```

Le estensioni possono essere mescolate; i nomi base devono essere quelli sopra.

Installazione:

```sh
./install-assets.sh /percorso/agli/asset
./check-assets.sh
```

I PDF generati finiscono in:

```text
TEXMFHOME/tex/latex/uniudletter-assets/
```

## Modalita DOTX

Per comodita e possibile fornire una directory contenente il modello Word
ufficiale `*intestata*.dotx` e il solo sigillo con nome canonico, ad esempio:

```text
Uniud_intestata_digitale25.dotx
uniud-sigillo-completo.svg
```

L'installer estrae dal DOTX la grafica della prima pagina e del `segue foglio`,
e deriva la base della carta intestata di dipartimento. Questa modalita e
specifica per la struttura dei modelli UNIUD 2025/2026.

## Asset locali per progetto

In alternativa all'installazione TDS si puo puntare a una directory locale:

```latex
\UniudAssetsPath{/percorso/asset-pdf}
```

oppure:

```latex
\UniudSetup{directory-assets={/percorso/asset-pdf}}
```

In questo caso la directory deve gia contenere i quattro PDF canonici.
