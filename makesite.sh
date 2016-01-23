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

XSLT=./xsltsrc

SRCARG=""
DSTARG=""
VALID="--novalid"
HTMLDTD="/usr/local/share/xml/xhtml/1.1"

case `uname -s` in
    Darwin*)
	STAT="stat -f %m"
	;;
    Linux*)
	STAT="stat -c %Y"
	;;
esac

while [ $# -gt 0 ]
do
    case "$1" in
	-h)
	    echo "usage: `basename $0` [--validate] <srcdir> <dstdir>" 2>&1
	    ;;

	--validate)
	    VALID=""
	    ;;
	
	-*) echo "`basename $0`: invalid option \"$1\"."
	    ;;

	*)  if [ -z $SRCARG ]; then
		SRCARG=$1
	    elif [ -z $DSTARG ]; then
		DSTARG=$1
	    else
		echo "ignored argument: $1" >&2
	    fi
	    ;;
    esac
    shift
done

SRC=${SRCARG:-${PWD}/src} # must be full paths (e.g., realpath)
DST=${DSTARG:-${PWD}/dst}

dodir () {
    for f in `find $1 -maxdepth 1 -type f 2> /dev/null`
    do
	echo "<file name=\"$(basename $f)\" lastmod=\"$($STAT $f)\"/>"
    done

    for dir in `find $1/* -type d -maxdepth 0 2> /dev/null`
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
     echo "</hier>")  \
	| xsltproc $VALID --nodtdattr \
		--path "$XSLT $HTMLDTD" $XSLT/makesite.xsl -
else
    echo "`basename $0`: ensure that \"$SRC\" and \"$DST\" exist."
fi

