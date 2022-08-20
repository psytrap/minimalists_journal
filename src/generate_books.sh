#!/bin/sh

PDF_DIR="../pdf/A6"
BOOK_DIR="../pdf/books"

rm -v $BOOK_DIR/*
mkdir -p $BOOK_DIR

book60pages()
{
  local planner=$1
  local title=$2
  local blanks=$3
  local pages
  local page_count="49"
  local pages_with_dir
  
  
  
  echo ; echo "Defining title and planner section..."
  pages="title_page.pdf"
  if [ "$blanks" = true ]; then
    page_count="45"
    pages="$pages blank.pdf"
    pages="$pages blank.pdf"
  fi
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"
  pages="$pages $planner"

  # pages = x + 15   # x + 57 = 72  # x = 15
  echo ; echo "Defining bullet section..."
  for i in $(seq "$page_count") ; do pages="$pages bullet_sheet_g5mm_i80.pdf" ; done

  if [ "$blanks" = true ]; then
    echo ; echo "Defining back cover page..."
    pages="$pages blank.pdf"
    pages="$pages blank.pdf"
  fi
  
  for i in $pages ; do pages_with_dir="$pages_with_dir ${PDF_DIR}/$i" ; done
  
  echo ; echo "Merging pdfs and adding bleed area..."
  echo "$pages_with_dir"
  gs -o "$BOOK_DIR/${title}_60pages.pdf" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=297 -dDEVICEHEIGHTPOINTS=420 \
    -dFIXEDMEDIA -c "<</PageOffset [0 0]>> setpagedevice" -f $pages_with_dir
  gs -o "$BOOK_DIR/${title}_60pages_with_bleed.pdf" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=314 -dDEVICEHEIGHTPOINTS=437 \
    -dFIXEDMEDIA -c "<</PageOffset [8 9]>> setpagedevice" -f $pages_with_dir
  #gs -o "$BOOK_DIR/work_60pages.pdf" -sDEVICE=pdfwrite $pages_with_dir
}

dotted()
{
  local page_count="$1"
  local title="$2"
  local pages
  local pages_with_dir
  
  local dotted_count=$( (echo "$page_count-2") | bc )

  pages="title_page.pdf"
  
  echo ; echo "Defining bullet section..."
  for i in $(seq "$dotted_count") ; do pages="$pages bullet_sheet_g5mm_i80.pdf" ; done
  for i in $pages ; do pages_with_dir="$pages_with_dir ${PDF_DIR}/$i" ; done
  
  dotted_book="$BOOK_DIR/${title}_${page_count}pages"
  gs -o "${dotted_book}.tmp.pdf" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=297 -dDEVICEHEIGHTPOINTS=420 \
    -dFIXEDMEDIA -c "<</PageOffset [0 0]>> setpagedevice" -f $pages_with_dir

  echo "Imprint..."
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -o "$BOOK_DIR/bullet_sheet.imprint.tmp.pdf" \
      "./imprint.ps" "${PDF_DIR}/bullet_sheet_g5mm_i80.pdf"
  
  
  


  #gs  -sPageList="$page_count" -o "${dotted_book}.last.tmp.pdf" -sDEVICE=pdfwrite "${dotted_book}.pdf"
  #gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="${dotted_book}.imprint.tmp.pdf" "./imprint.ps" "${dotted_book}.last.tmp.pdf"
  echo "..."
  gs  -o "${dotted_book}.pdf" -sDEVICE=pdfwrite \
      -f "${dotted_book}.tmp.pdf" "$BOOK_DIR/bullet_sheet.imprint.tmp.pdf"

  #echo "Add bleed..."
  #gs -o "${dotted_book}_with_bleed.pdf" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=314 -dDEVICEHEIGHTPOINTS=437 \
  #  -dFIXEDMEDIA -c "<</PageOffset [8 9]>> setpagedevice" -f "${dotted_book}.pdf"

  rm -v ${BOOK_DIR}/*.tmp.pdf
  
  
}

echo ; echo "Creating journal for work..."
book60pages weekly_planner_work.pdf monthly_work false

echo ; echo "Creating journal for personal use..."
book60pages weekly_planner.pdf monthly false

echo ; echo "Creating journal for work with blank..."
book60pages weekly_planner_work.pdf monthly_with_blank true

echo ; echo "Creating dotted journal..."
dotted 60 dotted
dotted 80 dotted


