# API di `uniudletter`

Questa pagina raccoglie l'API pubblica della classe. Per una lettera normale non
è necessario conoscere le `komavar` di KOMA-Script: i dati si impostano con
`\UniudSetup{...}` e con i comandi di alto livello descritti qui sotto.

## Esempio minimo: lettera personale di dipartimento

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
  email = {nome.cognome@uniud.it},
  sito = {uniud.it},
  firmatario = {Nome Cognome},
  ruolo = {Professore}
}

\UniudDestinatario{
  nome = {Prof.ssa Nome Cognome},
  struttura = {Università di Esempio},
  indirizzo = {via Esempio 1},
  cap = 00100,
  citta = Roma
}

\UniudOggetto{Oggetto della comunicazione}

\begin{document}
\begin{letter}{}
\opening{Gentile Professoressa,}
Testo della lettera.
\UniudFirma
\end{letter}
\end{document}
```

`\UniudDipartimento{...}` seleziona automaticamente denominazione e acronimo e
applica il profilo di footer minimale adatto a una lettera personale.

## Lingua

Per ora la documentazione e gli esempi ufficiali del pacchetto sono soltanto in
italiano. Questo non impedisce di usare la classe per una lettera in inglese.
Con XeLaTeX o LuaLaTeX, per esempio:

```latex
\usepackage{polyglossia}
\setmainlanguage{english}
```

La localizzazione inglese completa dell'interfaccia tipografica non è ancora
disponibile: le etichette prodotte automaticamente dalla classe restano in
italiano. Tutto il contenuto fornito dall'utente può invece essere scritto in
inglese.

## Modalità del documento

La modalità predefinita è **normale**. Non viene aggiunta automaticamente
alcuna dicitura sulla firma.

```latex
\UniudNormale
\UniudDigitale
\UniudAnalogico
```

Gli stessi valori possono essere impostati con:

```latex
\UniudSetup{documento = normale}
\UniudSetup{documento = digitale}
\UniudSetup{documento = analogico}
```

- `normale`: comportamento standard; `\UniudFirma` stampa ruolo e firmatario;
- `digitale`: aggiunge la dicitura relativa al documento informatico firmato
  digitalmente;
- `analogico`: seleziona il modello analogico con i campi tradizionali.

La firma digitale è quindi **opt-in**: usare `\UniudDigitale` solo quando la
dicitura è appropriata al documento che verrà effettivamente firmato.

## Tipo di intestazione

### Istituzionale

```latex
\UniudIstituzionale
```

Applica l'intestazione istituzionale. Il profilo predefinito del footer mostra:

- marchio UNIUD;
- certificazioni;
- blocco contatti;
- blocco fiscale;
- blocco responsabile/compilatore in modalità `auto`.

### Dipartimento

```latex
\UniudDipartimento{DPIA}
```

Sono riconosciuti:

```text
DIUM, DILL, DMIF, DPIA, DIES, DISG, DI4A, DMED
```

La chiave è case-insensitive. Il profilo predefinito è pensato per una
**lettera personale di dipartimento**:

- marchio UNIUD: attivo;
- certificazioni: attive;
- responsabile/compilatore: `auto`;
- contatti nel footer: disattivi;
- dati fiscali/bancari nel footer: disattivi.

I dati come indirizzo, telefono ed e-mail possono comunque essere forniti a
`\UniudSetup`: restano disponibili per intestazione e altri usi, ma non vengono
stampati nel footer finchè non si abilita il relativo blocco.

## `\UniudSetup`

### Identita' e struttura

```latex
\UniudSetup{
  acronimo = {...},
  struttura = {...},
  luogo = {...}
}
```

Normalmente `acronimo` e `struttura` non vanno impostati manualmente quando si
usa `\UniudDipartimento{...}`.

### Indirizzo e contatti

```latex
\UniudSetup{
  indirizzo = {via delle Scienze 206},
  cap = 33100,
  citta = Udine,
  provincia = UD,
  paese = Italia,
  telefono = {+39 0432 558400},
  fax = {+39 0432 558499},
  email = {nome.cognome@uniud.it},
  sito = {uniud.it}
}
```

`localita` è disponibile per i casi in cui serva impostare direttamente una
località già composta.

Quando `footer-contatti=true`, il footer riusa questi stessi dati: non esistono
campi duplicati specifici per il piè di pagina.

### Firma

```latex
\UniudSetup{
  firmatario = {Nome Cognome},
  ruolo = {Professore}
}
```

Nel corpo della lettera:

```latex
\UniudFirma
```

Il contenuto aggiuntivo della firma dipende dalla modalità documentale scelta.

## I tre blocchi informativi del footer

Marchio UNIUD e certificazioni sono componenti standard. I dati variabili
centrali sono invece organizzati in **tre soli blocchi logici**.

### 1. Responsabile e compilatore

```latex
\UniudSetup{
  responsabile = {Nome Cognome - nome.cognome@uniud.it},
  compilatore = {Nome Cognome - nome.cognome@uniud.it}
}
```

Il controllo è:

```latex
footer-responsabili = auto | true | false
```

Il default è `auto`.

| Valori forniti | `auto` |
| --- | --- |
| nessuno | blocco non mostrato |
| responsabile + compilatore | blocco mostrato |
| solo uno dei due | errore di compilazione |

L'errore evita di produrre accidentalmente un footer amministrativo incompleto.
Se si vuole deliberatamente ignorare i dati del blocco:

```latex
\UniudSetup{footer-responsabili = false}
```

Con `footer-responsabili=true` il blocco è richiesto esplicitamente e devono
essere valorizzati entrambi i campi.

### 2. Contatti

```latex
\UniudSetup{footer-contatti = true}
```

Il blocco usa insieme, quando valorizzati:

```text
indirizzo, cap, citta, provincia, paese,
telefono, fax, email, sito
```

I campi vuoti sono saltati e i separatori vengono costruiti automaticamente.
L'indirizzo del footer deriva dagli stessi dati usati dall'intestazione.

Default:

- intestazione istituzionale: `true`;
- intestazione di dipartimento: `false`.

### 3. Dati fiscali e bancari

```latex
\UniudSetup{footer-fiscale = true}
```

Il blocco comprende:

```text
codice-fiscale, partita-iva, abi, cab, cin, conto-corrente
```

CF e P.IVA hanno i valori istituzionali UNIUD predefiniti. ABI, CAB, CIN e conto
corrente compaiono solo quando sono valorizzati.

Default:

- intestazione istituzionale: `true`;
- intestazione di dipartimento: `false`.

### Esempio: dipartimento con footer amministrativo

```latex
\UniudDipartimento{DPIA}

\UniudSetup{
  responsabile = {Nome Cognome - nome.cognome@uniud.it},
  compilatore = {Nome Cognome - nome.cognome@uniud.it},
  footer-contatti = true,
  footer-fiscale = true
}
```

Non serve impostare `footer-responsabili=true`: con il default `auto`, la
presenza di entrambi i campi abilita il blocco automaticamente.

## Controlli avanzati del footer

Questi controlli sono disponibili, ma non sono normalmente necessari:

```latex
\UniudSetup{
  footer-prima-pagina = true,
  footer-marchio = true,
  footer-certificazioni = true
}
```

- `footer-prima-pagina=false`: elimina l'intero footer della prima pagina;
- `footer-marchio=false`: elimina il marchio istituzionale a sinistra;
- `footer-certificazioni=false`: elimina i marchi HR/certificazione a destra.

Marchio e certificazioni hanno default `true` sia nelle lettere istituzionali
sia in quelle di dipartimento.

Una nota libera aggiuntiva può essere impostata con:

```latex
\UniudSetup{pie-prima-pagina = {...}}
```

## Destinatario

```latex
\UniudDestinatario{
  nome = {Prof.ssa Nome Cognome},
  struttura = {Università di Esempio},
  indirizzo = {via Esempio 1},
  cap = 00100,
  citta = Roma
}
```

## Oggetto

```latex
\UniudOggetto{Oggetto della comunicazione}
```

## Protocollo e riferimenti

Il blocco protocollo è facoltativo. Se non viene impostato, non viene stampato
e non viene riservato spazio.

```latex
\UniudProtocollo{
  numero = {4},
  titolo = {14},
  classe = {2},
  fascicolo = {1}
}
```

Le stesse informazioni sono disponibili come chiavi di `\UniudSetup`:

```latex
\UniudSetup{
  protocollo = {...},
  titolo = {...},
  classe = {...},
  fascicolo = {...}
}
```

Per una normale lettera personale di dipartimento non è necessario impostarle.

## Riepilogo dei default

| Componente | Istituzionale | Dipartimento |
| --- | :---: | :---: |
| modalità documento | normale | normale |
| marchio footer | si | si |
| certificazioni footer | si | si |
| responsabile/compilatore | auto | auto |
| contatti footer | si | no |
| fiscale/bancario footer | si | no |
| protocollo senza dati | nascosto | nascosto |

## API compatta consigliata

Per il codice utente ordinario sono sufficienti soprattutto:

```latex
\UniudIstituzionale
\UniudDipartimento{DPIA}

\UniudNormale
\UniudDigitale
\UniudAnalogico

\UniudSetup{...}
\UniudDestinatario{...}
\UniudOggetto{...}
\UniudProtocollo{...}
\UniudFirma
```

Le `komavar` di KOMA-Script rimangono un dettaglio interno e non sono necessarie
per l'uso normale della classe.
