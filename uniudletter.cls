\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uniudletter}[2026/08/26 v0.2.0 Classe per lettere UNIUD]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrlttr2}}
\ProcessOptions\relax
\LoadClass[paper=a4,fontsize=10pt]{scrlttr2}
\RequirePackage{uniudletter}
