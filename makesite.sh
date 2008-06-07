#!/bin/sh
#
# $Id$
#   
# Copyright (c) 2008 Timothy Bourke. All rights reserved.
# 
# This program is free software; you can redistribute it and/or 
# modify it under the terms of the "BSD License" which is 
# distributed with the software in the file LICENSE.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the BSD
# License for more details.
#

SRC=`realpath ${1:-./src}`
DST=`realpath ${2:-./dst}`

XSLT=./xsltsrc

dodir () {
    for f in `find $1 -depth 1 -type f 2> /dev/null`
    do
	echo "<file name=\"$(basename $f)\" \
		    lastmod=\"$(stat -t %Y%m%d%H%M%S -f %Sm $f)\"/>"
    done

    for dir in `find $1/* -type d -maxdepth 0`
    do
	echo "<dir name=\"$(basename $dir)\">"
	dodir $dir
	echo "</dir>"
    done
}

if [ -d "$SRC" -a -d "$DST" ]; then
    (echo "<hier>"
     echo "<filehier name=\"src\" path=\"$SRC\">"
     dodir $SRC
     echo "</filehier>"
     echo "<filehier name=\"dst\" path=\"$DST\">"
     dodir $DST
     echo "</filehier>"
# With validation:
#    echo "</hier>") | xsltproc --paths $XSLT/ $XSLT/makesite.xsl -
# No validation:
     echo "</hier>") | xsltproc --novalid $XSLT/makesite.xsl -
else
    echo `basename $0`: ensure that \"$SRC\" and \"$DST\" exist.
fi

