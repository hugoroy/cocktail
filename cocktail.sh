#!/bin/bash

VERBOSE=1
DEBUG=0

PROJET=MonProjet
URL_BASE='https://pad.exegetes.eu.org/p/g.DSXI1kGFT1gjor66$Abro-REP-Tele2-Principal/export/txt'
URL_GARDE='https://pad.exegetes.eu.org/p/g.DSXI1kGFT1gjor66$Abro-REP-Tele2-Garde/export/txt'


die() {
  echo -e "$@" >&2
  exit 1
}

verbose() {
  if test "$VERBOSE" -ne 0;
  then
    echo "$@"
  fi
}

debug() {
  if test "$DEBUG" -ne 0;
  then
    echo "$@"
  fi
}

init_check() {
  if test -e $LOCK_FILE;
  then
    die "$FUNCNAME lock=$LOCK_FILE exists. Wait compilation or erase it"
  fi

  for tool in touch curl pandoc pdflatex
  do
    local tool_location=$(command -v $tool)
    if test "$tool_location";
    then
      verbose "init_check() $tool=$tool_location"
    else
      die "init_check() $tool unavailable"
    fi
  done
}

mirror_pad() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME url filename'
  fi

  local url=$1
  local filename=$2
  verbose "$FUNCNAME url=$url filename=$filename"
  RESPONSE=$(curl --silent --show-error $url --output $filename 2>&1)
  RC=$?
  local errstr="$FUNCNAME url=$url filename$filename [RC:$RC] $RESPONSE"
  if test "$RC" -gt 0;
  then
    die "$errstr"
  fi

  verbose "$errstr"
}

pad2json() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die "usage: $FUNCNAME input_file output_file"
  fi

  local input=$1
  local output=$2
  verbose "$FUNCNAME input=$input output=$output"

  pandoc \
    -f markdown "$input" \
    -o "$output" -t json --self-contained
}

pad2docx() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME input_file output_file'
  fi

  local input=$1
  local output=$2
  local refdoc=../../exegetesDoc/pandocincludes/exegetes.docx
  verbose "$FUNCNAME input=$input output=$output"

  if ! test -e "$refdoc";
  then
    die "$FUNCNAME refdoc=$refdoc unavailable"
  fi

  pandoc \
    -f markdown "$input" \
    -o "$output" -t docx --self-contained --smart \
    --reference-docx="$refdoc" \
    --filter pandoc-citeproc \
    --filter ../../exegetesDoc/filters/docx.zsh \
    --filter ../../exegetesDoc/filters/nettoyage.zsh \
    --filter ../../exegetesDoc/filters/nettoyage-etendu.zsh
}

pad2html() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME input_file output_file'
  fi

  local input=$1
  local output=$2
  verbose "$FUNCNAME input=$input output=$output"

  pandoc \
    -f markdown "$input" \
    -o "$output" -t html --self-contained --smart \
    --filter pandoc-citeproc \
    --filter ../../exegetesDoc/filters/html.zsh \
    --filter ../../exegetesDoc/filters/nettoyage.zsh \
    --filter ../../exegetesDoc/filters/nettoyage-etendu.zsh
}

pad2markdown() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME input_file output_file'
  fi

  local input=$1
  local output=$2
  verbose "$FUNCNAME input=$input output=$output"

  pandoc \
    -f markdown "$input" \
    -o "$output" -t markdown --wrap=none --self-contained --smart \
    --reference-location=block --reference-links \
    --filter pandoc-citeproc \
    --filter ../../exegetesDoc/filters/markdown.zsh \
    --filter ../../exegetesDoc/filters/nettoyage.zsh \
    --filter ../../exegetesDoc/filters/nettoyage-etendu.zsh
}

pad2tex() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME input_file output_file'
  fi

  local input=$1
  local output=$2
  verbose "$FUNCNAME input=$input output=$output"

  pandoc \
    -f markdown "$input" \
    -o "$output" -t latex --self-contained \
    --template ../../exegetesDoc/pandocincludes/exegetes.latex \
    --filter pandoc-citeproc \
    --filter ../../exegetesDoc/filters/latex.zsh \
    --filter ../../exegetesDoc/filters/nettoyage.zsh \
    --filter pandoc-latex-environment \
    --filter ../../exegetesDoc/filters/paranumero.bash
}

tex2pdf() {
  debug "$FUNCNAME ARGS:$@"
  if test $# -ne 2;
  then
    die 'usage: $FUNCNAME input_file output_file'
  fi

  local input=$1
  local output=$2
  verbose "$FUNCNAME input=$input output=$output"

  mkdir pdftmp && \
  pdflatex -interaction=nonstopmode -output-directory=pdftmp "$input" >/dev/null
  pdflatex -interaction=nonstopmode -output-directory=pdftmp "$input" >/dev/null
  mv "pdftmp/$output" "./$output"

#  rm *.aux && rm *.out && rm *.log 
}

lock_project() {
  verbose "$FUNCNAME $PROJET locked with $LOCK_FILE"
  touch $LOCK_FILE
}

release_project() {
  verbose "$FUNCNAME $PROJET released"
  rm -f $LOCK_FILE
}

if test "$1";
then
  URL_BASE=$1
  tmp=${URL_BASE#*$}              # remove prefix ending in "$"
  tmp=${tmp%-Principal/export*}   # remove suffix starting with
  tmp=${tmp%-Garde/export*}       # remove suffix starting with
  PROJET=$tmp
fi


LOCK_FILE="$PROJET.lock"
echo "[$PROJET]"

mkdir -p "$PROJET"
cd "$PROJET" || die

init_check
lock_project
mirror_pad "$URL_BASE" "$PROJET.txt"
mirror_pad "$URL_GARDE" "garde.tex"
# hack specifique Abro Tele2
touch annexe-tableau.tex
pad2json "$PROJET.txt" "$PROJET.json"
pad2docx "$PROJET.txt" "$PROJET.docx"
pad2html "$PROJET.txt" "$PROJET.html"
pad2markdown "$PROJET.txt" "$PROJET.markdown.txt"
pad2tex "$PROJET.txt" "$PROJET.tex"
tex2pdf "$PROJET.tex" "$PROJET.pdf"
release_project
exit

