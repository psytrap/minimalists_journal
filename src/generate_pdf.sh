#!/bin/sh


rm ../pdf/*

loffice --convert-to pdf --outdir ../pdf/ ./*.odt

loffice --convert-to pdf --outdir ../pdf/ ./*.ods

python3 ./generate_bullet_sheet.py

inkscape ./bullet_sheet.svg --export-pdf="../pdf/bullet_sheet.pdf"
inkscape ./bullet_sheet_with_date.svg --export-pdf="../pdf/bulled_sheet_with_date.pdf"

rm *svg






