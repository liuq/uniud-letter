# uniud-letter
University of Udine LaTeX Letter template (based on corporate image)

## Installation

Put the `uniud.lco`, `dpia.lco`, `pollo.png` and `iso9001.png` files inside a directory into your TeX search path. Install the `Helvetica Neue Heavy` font systemwide (possibly also other `Helvetica Neue` fonts, if there are not available in your system).

For example, under MacOS X using TeXLive 2016, you can put those files into `~/Library/texmf/tex/latex/uniud-letter`.

In such a case you can issue the following command on a terminal session:

```bash
git clone https://github.com/liuq/uniud-letter.git ~/Library/texmf/tex/latex/uniud-letter
```

## Compilation

In order to compile the letters you **must** use XeLaTeX. Unfortunately, there is **no way** it can be used with PDFLaTeX because of the fonts.

## Example of use

Load the style with:

```LaTeX
\documentclass[dpia,subject=true]{scrlttr2}
\usepackage{polyglossia}
\setmainlanguage{italian}
```

Set the personal information fields:

```LaTeX
\setkomavar{fromname}{Prof. Luca Di Gaspero}
\setkomavar{signature}{Luca Di Gaspero}
\setkomavar{fromphone}{+39 0432 55 8242}
\setkomavar{frommobilephone}{+39 320 4366035}
\setkomavar{fromemail}{luca.digaspero@uniud.it}
\setkomavar{fromurl}{www.dpia.uniud.it/digaspero}
```

And then type your letter:

```LaTeX
\begin{document}
  \begin{letter}{Spett.li Signori Utenti \LaTeX \\
    dell'Università degli Studi di Udine \\
    \MakeUppercase{Loro Sedi}
    }
    \setkomavar{subject}{nuovo stile \LaTeX Uniud corporate image}
    \opening{Gentili signore e egregi signori,}
    ...
    \closing{Cordialità,}
    \ps{P.S.  Riporto di seguito lo schema di documento da cui è stata ottenuta questa lettera.}
    ...
    \vfill
    \encl{Non ce ne sono}
  \end{letter}
\end{document}
```

## Corrections, improvements

Corrections and improvements are very welcome, you can send me the patches or fork the project, make the improvements/corrections and then issue a pull request.

## License

MIT