#!/bin/sh
#
# pdfsplit [input.pdf] [first_page] [last_page] [output.pdf] 
#
# Example: pdfsplit big_file.pdf 10 20 pages_ten_to_twenty.pdf
#
# written by: Westley Weimer, Wed Mar 19 17:58:09 EDT 2008
#
# The trick: ghostscript (gs) will do PDF splitting for you, it's just not
# obvious and the required defines are not listed in the manual page. 

if [ $# -lt 4 ] 
then
        echo "Usage: pdfsplit input.pdf first_page last_page output.pdf"
        exit 1
fi
yes | gs -dBATCH -sOutputFile="$4" -dFirstPage=$2 -dLastPage=$3 -sDEVICE=pdfwrite "$1" >& /dev/null
