\NeedsTeXFormat{LaTeX2e}
\input{uniudletter-version.tex}
\ProvidesClass{uniudletter}[2026/08/26 v\UniudLetterVersion\space Classe per lettere UNIUD]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrlttr2}}
\ProcessOptions\relax
\LoadClass[paper=a4,fontsize=10pt]{scrlttr2}
\RequirePackage{uniudletter}
