#!/bin/sh


rm ../pdf/*

loffice --convert-to pdf --outdir ../pdf/ ./*.odt

loffice --convert-to pdf --outdir ../pdf/ ./*.ods

python3 ./generate_bullet_sheet.py

inkscape ./bullet_sheet.svg --export-pdf="../pdf/bullet_sheet.pdf"
inkscape ./bullet_sheet_with_date.svg --export-pdf="../pdf/bullet_sheet_with_date.pdf"


for pdf in ../pdf/A6/* ; do
  pdf=$(basename $pdf)
  echo $pdf
  # 4in x 6in ## 72 points/inch
  gs -o ../pdf/4x6inch/$pdf -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=288 -dDEVICEHEIGHTPOINTS=432 -dPDFFitPage -dFIXEDMEDIA ../pdf/A6/$pdf
done

rm *svg






