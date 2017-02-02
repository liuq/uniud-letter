# uniud-letter
University of Udine LaTeX Letter template (based on corporate image)

### Example of use

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