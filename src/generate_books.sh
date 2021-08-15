#!/bin/sh

PDF_DIR="../pdf/A6"
BOOK_DIR="../pdf/books"

rm -v "$BOOK_DIR/*"

book72pages()
{
  local planner=$1
  local title=$2
  local pages
  local pages_with_dir
  pages="title_page.pdf"
  pages="$pages blank.pdf"
  pages="$pages blank.pdf"
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"

  for i in $(seq 57) ; do pages="$pages bullet_sheet_g5mm_i80.pdf" ; done

  pages="$pages blank.pdf"
  pages="$pages blank.pdf"
  
  
  for i in $pages ; do pages_with_dir="$pages_with_dir ${PDF_DIR}/$i" ; done
  
  echo "$pages_with_dir"
  gs -o "$BOOK_DIR/${title}_72pages.pdf" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=314 -dDEVICEHEIGHTPOINTS=437 \
    -dFIXEDMEDIA -c "<</PageOffset [8 9]>> setpagedevice" -f $pages_with_dir
  #gs -o "$BOOK_DIR/work_72pages.pdf" -sDEVICE=pdfwrite $pages_with_dir
}


book72pages weekly_planner_work.pdf monthly_work

book72pages weekly_planner.pdf monthly
