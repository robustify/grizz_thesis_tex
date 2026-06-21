% MIT License
%
% Copyright (c) 2026 Micho Radovnikovich
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{grizz_thesis}
\LoadClass[12pt, oneside]{book}

% Class options
% dissertation: use "Dissertation" instead of "Thesis" on title page, and "Doctoral" instead of "Thesis" in committee listing.
% bookmarks: enable PDF bookmarks with hyperref.
\newif\ifdissertation
\newif\ifbookmarks
\DeclareOption{dissertation}{
  \dissertationtrue
}
\DeclareOption{bookmarks}{
  \bookmarkstrue
}
\ProcessOptions \relax

% Necessary packages
\RequirePackage[left=1.5in,right=1in,top=1in,bottom=1.25in, includefoot]{geometry} % Margins
\RequirePackage{graphicx} % For including images in figures
\RequirePackage{etoolbox} % For \gappto to accumulate committee members
\RequirePackage{fmtcount} % For \NUMBERstring to get "One", "Two", etc. in chapter titles
\RequirePackage[nonumberlist, nopostdot]{glossaries} % For the list of abbreviations
\RequirePackage{fancyhdr} % For custom page styles in the front matter
\RequirePackage{setspace} % For line spacing
\RequirePackage[explicit]{titlesec} % For custom chapter/section title formatting
\RequirePackage{titletoc} % For custom table of contents formatting
\RequirePackage{tocloft} % For custom table of contents formatting
\RequirePackage[normalem]{ulem} % For underlining section titles
\RequirePackage{array} % For custom table column types
\RequirePackage{times} % Only Times New Roman for now, will add more options later with the university's approval
\RequirePackage[all, defaultlines=3]{nowidow} % To prevent widows and orphans in the text
\ifbookmarks
  \RequirePackage[bookmarks, hidelinks, bookmarksopen, bookmarksnumbered]{hyperref} % For PDF bookmarks and hyperlinks
\fi

% Command to configure the page formatting for the front matter
% Call this at the very beginning of the document
\newcommand{\StartFrontMatter}{
  \singlespacing
  \pagestyle{normal}
  \pagenumbering{roman}
  \titleformat
    {\chapter}
    [display]
    {\normalfont\filcenter\singlespacing}
    {}
    {0pc}
    {##1}
  [\vspace*{3pc}]
}

% Command to configure the page formatting for the main body
% Call this after the front matter and before the first chapter.
\newcommand{\StartMainBody}{
  \pagenumbering{gobble}
  \pagenumbering{arabic}
  \newpage
  \renewcommand{\thechapter}{\NUMBERstring{chapter}}
  \renewcommand{\theHchapter}{\arabic{chapter}}
  \renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
  \renewcommand{\thesubsection}{\arabic{chapter}.\arabic{section}.\arabic{subsection}}
  \renewcommand{\thefigure}{\arabic{chapter}.\arabic{figure}}
  \renewcommand{\thetable}{\arabic{chapter}.\arabic{table}}
  \renewcommand{\theequation}{\arabic{chapter}.\arabic{equation}}
  \titleformat
    {\chapter}
    [display]
    {\normalfont\filcenter\singlespacing}
    {\vspace{0.15in}\MakeUppercase{\chaptertitlename~\thechapter}}
    {1pc}
    {##1}
    [\vspace*{2pc}]
  \doublespacing
}

% Command to configure the page formatting for the appendices
% Call this after the last chapter and before the first appendix.
% Don't call this if there are no appendices
\newcommand{\StartAppendices}{
  \setcounter{chapter}{0}
  \renewcommand\thefigure{\Alph{chapter}.\arabic{figure}}
  \renewcommand\thetable{\Alph{chapter}.\arabic{table}}
  \renewcommand\theequation{\Alph{chapter}.\arabic{equation}}
  \renewcommand\thesection{\Alph{chapter}.\arabic{section}}
  \gdef\@grizzappendixheaderpending{}
}

% Command to print the bibliography/references section at the end of the document.
% Call this at the end of the document, after the appendices if there are any. Otherwise,
% call this after the last chapter.
\newcommand{\PrintReferences}{
  \newpage
  \phantomsection
  \addcontentsline{toc}{chapter}{REFERENCES}
  \begingroup
  \singlespacing
  \renewcommand{\bibname}{\vspace*{10pt}REFERENCES}
  \bibliography{references}
  \endgroup
}

% TOC formatting for the APPENDICES label inserted by \GrizzAppendix (first call only)
\newcommand{\l@appendixheader}[2]{\vspace{\baselineskip}#1\par}
\newcommand*{\toclevel@appendixheader}{0}

% Accumulates non-chair committee members. Call \AddCommitteeMember{Name} for each one.
\newcommand{\advisorlist}{}
\newcommand{\AddCommitteeMember}[1]{%
  \ifx\advisorlist\empty
    \gdef\advisorlist{\noindent#1, Ph.D.}%
  \else
    \gappto\advisorlist{\\[0pt]\noindent#1, Ph.D.}%
  \fi
}

%%% Front matter pages

% Typesets the cover page that is printed on the front of the book cover.
\newcommand{\GrizzCoverPage} {
  \pagenumbering{gobble}
  \clearpage
  \thispagestyle{empty}
  \vspace*{10pt}
  \begin{center}
    \begin{large}
      \vspace{-23pt}\MakeUppercase{\thesistitle}\\ \vfill

      \ifdissertation DISSERTATION \else THESIS \fi FOR THE DEGREE OF \\

      \MakeUppercase{\degreename}\vfill

      \MakeUppercase{\studentname}\vfill

      OAKLAND UNIVERSITY\vspace{32pt}

      \the\year
    \end{large}
  \end{center}
  \newpage
  \pagenumbering{roman}
}

% Typesets the title page of the thesis/dissertation
\newcommand{\GrizzTitlePage}{
  \thispagestyle{empty}
  \clearpage
  \begin{center}
  \MakeUppercase{\thesistitle}\vspace{3pc}

  by\vspace{3pc}

  \MakeUppercase{\studentname}\vspace{6pc}

  A \ifdissertation dissertation \else thesis \fi submitted in partial fulfillment of the\\
  requirements for the degree of\vspace{3pc}

  \MakeUppercase{\degreename}\vspace{6pc}

  \the\year\vspace{3pc}

  Oakland University\\
  Rochester, Michigan\vspace{5pc}
  \end{center}

  \noindent \ifdissertation Doctoral \else Thesis \fi Advisory Committee: \vspace*{\baselineskip}

  \noindent\CommitteeChair, Ph.D., Chair
  \advisorlist
  \newpage
}

\newcommand{\GrizzCopyrightPage}{
  \thispagestyle{plain}
  \vspace*{\fill}
  \begin{center}
    \copyright\ Copyright by \studentname, \the\year \\
    All rights reserved
  \end{center}
  \vspace*{\fill}
  \newpage
}

\newcommand{\GrizzDedicationPage}{
  \thispagestyle{plain}
  \doublespacing
  \vspace*{\fill}
  \begin{center}
  \begin{minipage}{4in}
  \centering
  \textit{\input{dedication}}
  \end{minipage}
  \end{center}
  \vspace*{\fill}
  \singlespacing
  \newpage
}

\newcommand{\GrizzAcknowledgementsPage}{
  \thispagestyle{plain}
  \begin{center}
    {ACKNOWLEDGMENTS}\vspace{2pc}
    \phantomsection
    \addcontentsline{toc}{chapter}{ACKNOWLEDGMENTS}
  \end{center}

  \doublespacing
  \input{acknowledgements}

  \singlespacing
  \vspace{3\baselineskip}
  \hfill \makebox[0.5\linewidth]{\studentname\hfill}
  \newpage
}
\newcommand{\GrizzAbstractPage}{
  \pagestyle{plain}
  \begin{center}
    {ABSTRACT}\vspace{2pc}
    \phantomsection
    \addcontentsline{toc}{chapter}{ABSTRACT}

    \thesistitle \vspace{1pc}

    by \vspace{1pc}

    \studentname \vspace{1pc}
  \end{center}

  \noindent Adviser: \CommitteeChair, Ph.D.\vspace{2pc}

  \doublespacing
  \input{abstract}

  \singlespacing
  \newpage
}
%%%

%%%%%% Style configurations for the front matter

%%% Table of contents
\fancypagestyle{tocstyle}{
  \fancyhf{}
  \lhead{}
  \rhead{}
  \chead{TABLE OF CONTENTS---Continued}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \addtolength{\headsep}{2.5pt}
}
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\setlength{\cftbeforetoctitleskip}{-7.5pt}
\setlength{\cftaftertoctitleskip}{0.38in}
\renewcommand{\cfttoctitlefont}{\hfill\normalfont\MakeUppercase}
\renewcommand{\cftaftertoctitle}{\hfill}
\cftsetpnumwidth{0in}
\cftsetrmarg{1.5in}

% Chapter entries in the table of contents
\renewcommand{\cftchapindent}{0pt}
\renewcommand{\cftchapnumwidth}{0pt}
\renewcommand{\cftchappresnum}{CHAPTER~}
\renewcommand{\cftchapaftersnumb}{\nopagebreak \\}
\renewcommand{\cftchapfont}{\normalfont}
\renewcommand{\cftchappagefont}{\normalfont}
\renewcommand{\cftbeforechapskip}{1pc}
% Tell hyperref to use plain arabic numbers when \NUMBERstring appears in a PDF string.
\ifbookmarks
  \pdfstringdefDisableCommands{\def\NUMBERstring#1{\number\value{#1}}}%
\fi
% Suppress extra lof/lot spacing added by \@chapter.
% Runs at \begin{document} so hyperref has already set up \Hy@org@chapter.
\AtBeginDocument{%
  \makeatletter
  \@ifundefined{Hy@org@chapter}{%
    \patchcmd{\@chapter}{\addtocontents{lof}{\protect\addvspace{10\p@}}}{}{}{}%
    \patchcmd{\@chapter}{\addtocontents{lot}{\protect\addvspace{10\p@}}}{}{}{}%
  }{%
    \patchcmd{\Hy@org@chapter}{\addtocontents{lof}{\protect\addvspace{10\p@}}}{}{}{}%
    \patchcmd{\Hy@org@chapter}{\addtocontents{lot}{\protect\addvspace{10\p@}}}{}{}{}%
  }%
  \makeatother
}

% Section entries in the table of contents
\renewcommand{\cftsecindent}{0.88in}
\renewcommand{\cftsecnumwidth}{0.37in}
\renewcommand{\cftsecpresnum}{}
\renewcommand{\cftsecaftersnum}{.~}
\renewcommand{\cftsecfont}{\normalfont}
\renewcommand{\cftsecpagefont}{\normalfont}
\renewcommand{\cftbeforesecskip}{1pc}

% Subsection entries in the table of contents
\renewcommand{\cftsubsecindent}{1.19in}
\renewcommand{\cftsubsecnumwidth}{0.55in}
\renewcommand{\cftsubsecpresnum}{}
\renewcommand{\cftsubsecaftersnum}{.}
\renewcommand{\cftsubsecfont}{\normalfont}
\renewcommand{\cftsubsecpagefont}{\normalfont}
\renewcommand{\cftbeforesubsecskip}{1pc}
%%%

% List of figures
\fancypagestyle{lofstyle}{
  \fancyhf{}
  \lhead{}
  \rhead{}
  \chead{LIST OF FIGURES---Continued}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}
\renewcommand{\listfigurename}{LIST OF FIGURES}
\renewcommand{\cftloftitlefont}{\hfill\normalfont\MakeUppercase}
\renewcommand{\cftafterloftitle}{\hfill}
\setlength{\cftbeforeloftitleskip}{-0.07in}
\setlength{\cftafterloftitleskip}{0.55in}
\renewcommand{\cftdot}{}
\renewcommand{\cftfigpresnum}{Figure }
\renewcommand{\cftfigindent}{0pc}
\renewcommand{\cftfignumwidth}{1.0in}
\renewcommand{\cftfigafterpnum}{\vspace{12pt}}

% List of tables
\fancypagestyle{lotstyle}{
  \fancyhf{}
  \lhead{}
  \rhead{}
  \chead{LIST OF TABLES---Continued}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}
\renewcommand{\listtablename}{LIST OF TABLES}
\renewcommand{\cftlottitlefont}{\hfill\normalfont\MakeUppercase}
\renewcommand{\cftafterlottitle}{\hfill}
\setlength{\cftbeforelottitleskip}{-7.5pt}
\setlength{\cftafterlottitleskip}{0.38in}
\renewcommand{\cftdot}{}
\renewcommand{\cfttabpresnum}{Table }
\renewcommand{\cfttabindent}{0pc}
\renewcommand{\cfttabnumwidth}{1.0in}
\renewcommand{\cfttabafterpnum}{\vspace{12pt}}

% List of abbreviations
\fancypagestyle{loastyle}{
  \fancyhf{}
  \lhead{}
  \rhead{}
  \chead{LIST OF ABBREVIATIONS---Continued}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}
\newglossarystyle{grizz_glossary}{
  \renewcommand{\glossaryname}{\vspace{-0.44in}LIST OF ABBREVIATIONS}
  % put the glossary in the tabular environment:
  \renewenvironment{theglossary}%
    {\noindent\begin{longtable}{p{1.13in}p{4.37in}}}{\end{longtable}}%
  % have nothing after \begin{theglossary}:
  \renewcommand*{\glossaryheader}{}%
  % have nothing between glossary groups:
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand*{\glsgroupskip}{}%

  \renewcommand*{\glossentry}[2]{
    \glstarget{##1}{\glossentryname{##1}}\hfill & \glossentrydesc{##1}\hfill \vspace{12pt}\\
  }
}
%%%%%%

%%% Style configurations for the main body

% Main body formatting
\fancypagestyle{normal}{
  \fancyhf{}
  \lhead{}
  \rhead{}
  \chead{}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}

% Word-wrapped table columns
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}

% Indentation
\raggedright
\setlength{\parindent}{0.5in}

% Figure placement spacing
\setlength{\intextsep}{0.75in}
\setlength{\textfloatsep}{0.75in}
\setlength{\floatsep}{0.75in}

% Heading formatting
\titlespacing{\chapter}{0pt}{-3pc}{0pc}

% Section titles
\titleformat
  {\section}
  {\normalfont\filcenter}
  {}
  {0em}
  {\thesection~\uline{#1}}
  [\vspace*{-1pc}]

% Subsection titles
\titleformat
  {\subsection}
  {\normalfont\filright}
  {\thesubsection~\uline{#1}}
  {0em}
  {\vspace*{-0.5pc}}

% Equations
\DeclareMathSizes{12}{12}{10}{10}

%%%

%%% Appendix formatting

\newcounter{appendixnumber}
\newcounter{appendixsectionnumber}[appendixnumber]
\newcounter{appendixequationnumber}[appendixnumber]
\newcounter{appendixfigurenumber}[appendixnumber]
\renewcommand{\theappendixnumber}{\Alph{appendixnumber}}

\newcommand{\GrizzAppendix}[1]{
  \stepcounter{chapter}
  \setcounter{equation}{0}
  \setcounter{figure}{0}
  \setcounter{section}{0}
  \refstepcounter{appendixnumber}
  \newpage
  \phantomsection
  \@ifundefined{@grizzappendixheaderpending}{}{%
    \addtocontents{toc}{\protect\vspace{\baselineskip}APPENDICES}%
    \global\let\@grizzappendixheaderpending\undefined
  }%
  \addcontentsline{toc}{section}{\texorpdfstring{\protect\makebox[0.3in][l]{\Alph{appendixnumber}.} #1}{\Alph{appendixnumber}. #1}}
  \vspace*{\fill}\begin{center} APPENDIX~\Alph{appendixnumber} \\ \MakeUppercase{#1}\end{center} \vspace*{\fill}\newpage
}

% Custom section to get A.x section numbering
\newcommand{\GrizzAppendixSection}[1]{
  \refstepcounter{appendixsectionnumber}
  \refstepcounter{section}
  \phantomsection
  \addcontentsline{toc}{subsection}{\texorpdfstring{\protect\makebox[0.45in][l]{\Alph{appendixnumber}.\arabic{appendixsectionnumber}.} #1}{\Alph{appendixnumber}.\arabic{appendixsectionnumber}. #1}}
  \section*{#1}
}

\newcommand{\PrintLists}{
  \newgeometry{top=1.5in, bottom=1.25in, left=1.5in, right=1in, includefoot}
  \newpage
  \pagestyle{tocstyle}
  ~\vspace{-0.625in}
  \tableofcontents
  \newpage

  \phantomsection
  \addcontentsline{toc}{chapter}{LIST OF TABLES}
  \begingroup
  \pagestyle{lotstyle}
  ~\vspace{-0.625in}
  \listoftables
  \newpage
  \endgroup

  \phantomsection
  \addcontentsline{toc}{chapter}{LIST OF FIGURES}
  \begingroup
  \pagestyle{lofstyle}
  \makeatletter
  \let\ps@plain\ps@normal
  \makeatother
  ~\vspace{-0.625in}
  \listoffigures
  \newpage
  \endgroup

  \phantomsection
  \addcontentsline{toc}{chapter}{LIST OF ABBREVIATIONS}
  \begingroup
  \pagestyle{loastyle}
  \makeatletter
  \let\ps@plain\ps@normal
  \makeatother
  \printglossary[style=grizz_glossary]
  \newpage
  \endgroup

  \restoregeometry

  \pagestyle{normal}
}
\setlength{\headheight}{15pt}
\makeglossaries

%%%

