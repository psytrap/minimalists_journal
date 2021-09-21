#!/bin/sh

echo ; echo "Clean-up..."
rm -v ../pdf/A6/*
rm -v ../pdf/4x6inch/*
rm -v ../pdf/A5/*

echo ; echo "Convert docs..."
loffice --convert-to pdf --outdir ../pdf/A6/ ./blank.odt ./title_page.odt
loffice --convert-to pdf --outdir ../pdf/A6/ ./weekly*.ods


echo ; echo "Generate bullet sheets..."
rm -vf bullet_sheet*svg
grid="5"
echo ; echo "- Grid: ${grid}mm"
for i in 70 80 90 ; do
  echo ; echo "- Intensity: $i"
  # A6
  python3 ./generate_bullet_sheet.py --grid $grid --intensity $i --output bullet_sheet_g${grid}mm_i$i.svg
  python3 ./generate_bullet_sheet.py --grid $grid --intensity $i --date --output bullet_sheet_with_date_g${grid}mm_i$i.svg
  inkscape ./bullet_sheet_g${grid}mm_i$i.svg --export-pdf="../pdf/A6/bullet_sheet_g${grid}mm_i$i.pdf"
  inkscape ./bullet_sheet_with_date_g${grid}mm_i$i.svg --export-pdf="../pdf/A6/bullet_sheet_with_date_g${grid}mm_i$i.pdf"
  # A5
  python3 ./generate_bullet_sheet.py --size "148x210" --grid $grid --intensity $i --output bullet_sheet_A5_g${grid}mm_i$i.svg
  python3 ./generate_bullet_sheet.py --size "148x210" --grid $grid --intensity $i --date --output bullet_sheet_with_date_A5_g${grid}mm_i$i.svg
  inkscape ./bullet_sheet_A5_g${grid}mm_i$i.svg --export-pdf="../pdf/A5/bullet_sheet_g${grid}mm_i$i.pdf"
  inkscape ./bullet_sheet_with_date_A5_g${grid}mm_i$i.svg --export-pdf="../pdf/A5/bullet_sheet_with_date_g${grid}mm_i$i.pdf"
done

echo ; sleep 5
rm -v *svg

echo ; echo "Convert to 4x6 inch..."
for pdf in ../pdf/A6/* ; do
  pdf=$(basename $pdf)
  echo $pdf
  # 4in x 6in ## 101.6x152.4 mm vs 105x148 mm ## 72 points/inch
  gs -o ../pdf/4x6inch/$pdf -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=288 -dDEVICEHEIGHTPOINTS=432 -dPDFFitPage -dFIXEDMEDIA ../pdf/A6/$pdf
done


# weekly / tracker / quick
echo ; echo "Convert A5 docs..."
loffice --convert-to pdf --outdir ../pdf/A5/ ./A5*.ods
loffice --convert-to pdf --outdir ../pdf/A5/ ./calendars/A5*.ods

# TODO use tmp files

