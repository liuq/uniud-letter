# Installazione di `uniudletter`

## Requisiti

- TeX Live o MacTeX con KOMA-Script, `fontspec`, TikZ/PGF, `expl3`;
- XeLaTeX (motore verificato);
- `l3build` per installazione, test e packaging.

Work Sans e consigliato come fallback tipografico. Gotham e LL Circular non
sono distribuiti dal progetto.

Il sigillo UNIUD necessario al layout e gia incluso nel repository in SVG e in
PDF; non servono script o dipendenze grafiche aggiuntive durante
l'installazione o la compilazione.

## Installazione

Dalla radice del progetto:

```sh
l3build install
```

oppure:

```sh
./install.sh
```

Verifica da una directory diversa dal repository:

```sh
cd ~
kpsewhich uniudletter.cls
kpsewhich uniudletter.sty
kpsewhich uniud.lco
kpsewhich uniud-sigillo-blu.pdf
```

## Installazione TDS

Dopo:

```sh
l3build ctan
```

viene prodotto anche `uniudletter.tds.zip`, che puo essere installato con:

```sh
unzip uniudletter.tds.zip -d "$(kpsewhich -var-value=TEXMFHOME)"
mktexlsr "$(kpsewhich -var-value=TEXMFHOME)"
```

## Disinstallazione

```sh
./uninstall.sh
```

## Documentazione dell'API

Dopo l'installazione, vedere `README.md` per l'avvio rapido e `API.md` per la
documentazione completa dell'interfaccia pubblica, inclusi modalita' del
documento, profili istituzionale/dipartimento e i tre blocchi logici del footer.

## Sviluppo

```sh
l3build check
make examples
l3build ctan
```
