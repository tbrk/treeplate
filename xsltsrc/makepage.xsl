<?xml version="1.0"?>
<!-- $Id$
  -  
  -  Copyright (c) 2008 Timothy Bourke. All rights reserved.
  -
  -  This program is free software; you can redistribute it and/or 
  -  modify it under the terms of the "BSD License" which is 
  -  distributed with the software in the file LICENSE.
  -
  -  This program is distributed in the hope that it will be useful, but
  -  WITHOUT ANY WARRANTY; without even the implied warranty of
  -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the BSD
  -  License for more details.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml" version="1.0">

  <xsl:output method="xml"
	      indent="yes"
	      omit-xml-declaration="yes"
	      standalone="yes"
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:include href="makemenu.xsl"/>
  <xsl:include href="makepath.xsl"/>
  <xsl:include href="rellinks.xsl"/>
  <xsl:include href="redirect.xsl"/>
  <xsl:include href="copycontent.xsl"/>
  <xsl:include href="makehead.xsl"/>
  <xsl:include href="makemisc.xsl"/>

  <xsl:template match="/sitepage">
    <xsl:param name="siteitem"/>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:variable name="sitetree" select="$siteitem/ancestor::sitetree[last()]"/>
    <xsl:variable name="items" select="$siteitem/ancestor-or-self::item"/>
    <xsl:variable name="dirs" select="$items/@directory"/>
    <xsl:variable name="file" select="$siteitem/file/text()"/>

    <xsl:variable name="itempath">
      <xsl:apply-templates mode="makepath" select="$items"/>
    </xsl:variable>

    <xsl:variable name="dirpath">
      <xsl:apply-templates mode="makepath" select="$dirs"/>
    </xsl:variable>

    <xsl:variable name="filepath">
      <xsl:choose>
        <xsl:when test="count(dirs)&gt;0">
          <xsl:value-of select="concat($dirpath, '/', $file)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$file"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
      <xsl:choose>
        <!-- ** content -->
        <xsl:when test="content">
          <head>
            <xsl:apply-templates mode="makehead" select=".">
              <xsl:with-param name="siteitem" select="$siteitem"/>
            </xsl:apply-templates>
          </head>
          <body>
            <div id="container">
              <div id="content">
                <xsl:element name="div">
                  <xsl:choose>

                    <xsl:when test="content/@mainid">
                      <xsl:attribute name="id">
                        <xsl:value-of select="content/@mainid"/>
                      </xsl:attribute>
                    </xsl:when>

                    <xsl:otherwise>
                      <xsl:attribute name="id">main</xsl:attribute>
                    </xsl:otherwise>

                  </xsl:choose>

                  <xsl:attribute name="class">main</xsl:attribute>
                  <xsl:apply-templates mode="copy" select="content/*"/>
                </xsl:element>

		<xsl:if test="count(content//footnote) > 0">
		  <div class="footnotes">
		    <ol>
		      <xsl:apply-templates select="content//footnote"
					   mode="makefootnote"/>
		    </ol>
		  </div>
		</xsl:if>

              </div>

              <xsl:if test="not(content/@footer = 'no')">
                <div id="footer">
                  <xsl:choose>
                    <xsl:when test="/sitepage/author">
                      <xsl:apply-templates select="/sitepage/author"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates
			select="($siteitem/ancestor-or-self::*/author)[last()]"/>
                    </xsl:otherwise>
                  </xsl:choose>

                  <span id="date">
                    <xsl:choose>

                      <xsl:when test="starts-with(lastmod, '$')">
                        <xsl:value-of
			  select="substring-before(substring-after(lastmod, '$'), '$')"/>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:value-of select="lastmod"/>
                      </xsl:otherwise>

                    </xsl:choose>
                  </span>
                </div>
              </xsl:if>
            </div>

            <xsl:apply-templates mode="makemenu" select="$sitetree">
              <xsl:with-param name="page" select="$itempath"/>
              <xsl:with-param name="dirs" select="$dirs"/>
            </xsl:apply-templates>
          </body>
        </xsl:when>

        <!-- ** redirect -->
        <xsl:when test="redirect">
          <xsl:apply-templates mode="redirect" select=".">
            <xsl:with-param name="siteitem" select="$siteitem"/>
          </xsl:apply-templates>
        </xsl:when>

      </xsl:choose>
    </html>
  </xsl:template>

  <!-- Put the author details in the footer -->
  <xsl:template match="author">
    <span id="author">Author:
	<xsl:element name="a">
	    <xsl:attribute name="href">
		<xsl:value-of select="@href"/>
	    </xsl:attribute>
	    <xsl:value-of select="text()"/>
	</xsl:element>
    </span>
  </xsl:template>

</xsl:stylesheet>
