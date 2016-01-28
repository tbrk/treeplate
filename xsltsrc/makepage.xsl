<?xml version="1.0"?>
<!-- Copyright (c) 2008 Timothy Bourke. All rights reserved.
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
  <xsl:include href="makenav.xsl"/>
  <xsl:include href="makepath.xsl"/>
  <xsl:include href="redirect.xsl"/>
  <xsl:include href="copycontent.xsl"/>
  <xsl:include href="makehead.xsl"/>
  <xsl:include href="makemisc.xsl"/>
  <xsl:include href="rellinks.xsl"/>

  <xsl:template match="/sitepage">
    <xsl:param name="siteitem"/>
    <xsl:param name="rellinkprefix"/>

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

    <xsl:if test="prepage">
      <xsl:apply-templates mode="copy" select="prepage/text()"/>
    </xsl:if>

    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
      <xsl:choose>
        <!-- ** content -->
        <xsl:when test="content">
	  <head>
	    <xsl:apply-templates mode="makehead" select=".">
	      <xsl:with-param name="siteitem" select="$siteitem"/>
	    </xsl:apply-templates>
	    <xsl:apply-templates mode="backlink" select="style">
              <!--<xsl:with-param name="relpath" select="$rellinkprefix"/>-->
	    </xsl:apply-templates>
	  </head>
          <body>
            <div class="tp-all"><div class="tp-all-inner">
              <xsl:for-each select="$sitetree/navbar">
                <div class="tp-navbar-container">
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('navbar ', @class)"/>
                  </xsl:attribute>
                  <xsl:apply-templates mode="makenav" select="$sitetree">
                    <xsl:with-param name="rootname" select="text()"/>
                    <xsl:with-param name="page" select="$itempath"/>
                    <xsl:with-param name="dirs" select="$dirs"/>
                    <xsl:with-param name="linkroot"
                        select="$siteitem/file/@rellinkprefix"/>
                  </xsl:apply-templates>
                </div>
              </xsl:for-each>
              <div class="tp-content-container">
                <div class="tp-content">
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
                    <xsl:apply-templates mode="copy"
                        select="content/* | content/text() | content/comment()"/>
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
                  <div class="tp-footer"><div class="tp-footercontent">
                    <xsl:choose>
                      <xsl:when test="/sitepage/author">
                        <xsl:apply-templates select="/sitepage/author"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates
                          select="($siteitem/ancestor-or-self::*/author)[last()]"/>
                      </xsl:otherwise>
                    </xsl:choose>

                    <div class="tp-footer-date">
                      <xsl:choose>

                        <xsl:when test="starts-with(lastmod, '$')">
                          <xsl:value-of
                            select="substring-before(substring-after(lastmod, '$'), '$')"/>
                        </xsl:when>

                        <xsl:otherwise>
                          <xsl:value-of select="lastmod"/>
                        </xsl:otherwise>

                      </xsl:choose>
                    </div>
                  </div></div>
                </xsl:if>
              </div>

              <xsl:apply-templates mode="makemenu" select="$sitetree">
                <xsl:with-param name="page" select="$itempath"/>
                <xsl:with-param name="dirs" select="$dirs"/>
                <xsl:with-param name="linkroot"
                    select="$siteitem/file/@rellinkprefix"/>
              </xsl:apply-templates>

              <xsl:apply-templates mode="backlink" select="$siteitem">
                <xsl:with-param name="match" select="'script'"/>
                <xsl:with-param name="relpath" select="$siteitem/file/@rellinkprefix"/>
              </xsl:apply-templates>

              <xsl:apply-templates mode="backlink" select="script">
                <!--<xsl:with-param name="relpath" select="$rellinkprefix"/>-->
              </xsl:apply-templates>
            </div></div>
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

    <xsl:if test="postpage">
      <xsl:apply-templates mode="copy" select="postpage/text()"/>
    </xsl:if>
  </xsl:template>

  <!-- Put the author details in the footer -->
  <xsl:template match="author">
    <div class="tp-footer-author">Written by:
	<xsl:element name="a">
	    <xsl:attribute name="href">
		<xsl:value-of select="@href"/>
	    </xsl:attribute>
	    <xsl:value-of select="text()"/>
	</xsl:element>
    </div>
  </xsl:template>

</xsl:stylesheet>
