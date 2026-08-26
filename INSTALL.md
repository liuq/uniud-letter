# Installazione di `uniudletter`

## Requisiti

- TeX Live o MacTeX con KOMA-Script, `fontspec`, TikZ/PGF, `expl3`;
- XeLaTeX (motore verificato);
- `l3build` per installazione, test e packaging.

I font proprietari e gli asset grafici UNIUD **non sono inclusi**.
Work Sans e consigliato come fallback d'ufficio.

## 1. Installare il codice

Dalla radice del progetto:

```sh
l3build install
```

oppure:

```sh
./install.sh
```

Verifica:

```sh
kpsewhich uniudletter.cls
kpsewhich uniudletter.sty
kpsewhich uniud.lco
```

## 2. Installare gli asset UNIUD separatamente

Preparare una directory/ZIP contenente i quattro asset canonici (PDF/SVG/EPS/PNG)
oppure il modello Word ufficiale `*intestata*.dotx` piu il sigillo canonico.
Quindi:

```sh
./install-assets.sh /percorso/asset-uniud
./check-assets.sh
```

L'installer converte tutto in PDF e installa in:

```text
TEXMFHOME/tex/latex/uniudletter-assets/
```

La conversione SVG usa Inkscape se disponibile, altrimenti `rsvg-convert`.
Vedi `ASSETS.md` per nomi canonici e modalita DOTX.

## Asset locali senza installazione

Se si preferisce tenere gli asset nel progetto:

```latex
\UniudAssetsPath{/percorso/asset-pdf}
```

oppure:

```latex
\UniudSetup{directory-assets={/percorso/asset-pdf}}
```

La directory locale deve contenere i quattro PDF canonici descritti in
`ASSETS.md`.

## Installazione TDS

Dopo `l3build ctan` viene prodotto un archivio TDS. Lo si puo estrarre in
`TEXMFHOME`:

```sh
unzip uniudletter.tds.zip -d "$(kpsewhich -var-value=TEXMFHOME)"
mktexlsr "$(kpsewhich -var-value=TEXMFHOME)"
```

L'archivio TDS installa **solo il codice**; gli asset vanno installati a parte.

## Disinstallazione

```sh
./uninstall.sh
```

Gli asset esterni non vengono rimossi automaticamente. Per rimuoverli:

```sh
rm -rf "$(kpsewhich -var-value=TEXMFHOME)/tex/latex/uniudletter-assets"
mktexlsr "$(kpsewhich -var-value=TEXMFHOME)"
```

## Sviluppo

```sh
l3build check
l3build ctan
```

Per compilare gli esempi grafici occorre prima installare gli asset:

```sh
./check-assets.sh
make examples
```
