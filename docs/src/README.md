% README: Instructions for rendering th Chemlogic papers from source. 
% This file is from Chemlogic, a logic programming computer chemistry system  
% <http://icebergsystems.ca/chemlogic>  
% (C) Copyright 2012-2015 Nichlolas Paun 




## Contents ##
1. Description
2. Building `Chemlogic-paper.tex`
3. Building `Chemlogic-paper-extended.tex`

## 1. Description ##

These files (`Chemlogic-paper` and `Chemlogic-paper-extended`) are the source files for my two papers on Chemlogic. 
These papers were produced using LyX and can easily be built using it. To export to PDF using `pdflatex`:  
	
	`lyx -e pdf2 <file>`

Plain TeX files (and the BibTeX bibliography) are also included.
The BibTeX bibliography style used is `plainurl.bst`, which is not included with all TeX distributions, so I have provided a copy.

Instructions for building the TeX files are included below.

## 2. Building `Chemlogic-paper.tex` ##

1. `pdflatex Chemlogic-paper` (prepares the paper)
2. `bibtex Chemlogic-paper.1` (produces the bibliography)
3. `pdflatex Chemlogic-paper` (re-generates the document)
4. `pdflatex Chemlogic-paper` (re-calculates page numbering)

The output file will be called `Chemlogic-paper.tex`.

## 3. Building `Chemlogic-paper-extended.tex` ##

1. `pdflatex Chemlogic-paper-extended` (prepares the paper)
2. `bibtex Chemlogic-paper-extended` (produces the bibliography)
3. `pdflatex Chemlogic-paper-extended` (re-generates the document)
4. `pdflatex Chemlogic-paper-extended` (re-calculates page numbering)

The output file will be called `Chemlogic-paper-extended.tex`.
