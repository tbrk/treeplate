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
		xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
		version="1.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="sitetree" mode="makemap">
    <xsl:param name="srcpath"/>

    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <xsl:apply-templates select="item" mode="sitemap">
        <xsl:with-param name="path" select="concat(rooturl/text(), '/')"/>
        <xsl:with-param name="srcpath" select="$srcpath"/>
      </xsl:apply-templates>
    </urlset>
  </xsl:template>

  <xsl:template match="item[not(@directory)]" mode="sitemap">
    <xsl:param name="path"/>
    <xsl:param name="srcpath"/>

    <xsl:if test="not(@sitemap = 'no')">
      <url>
        <loc>
          <xsl:value-of select="concat($path, file, '.html')"/>
        </loc>
        <xsl:apply-templates select="." mode="urldetail"/>
        <xsl:apply-templates mode="getdate" select="document(concat($srcpath, file, '.xml'))"/>
      </url>
    </xsl:if>

    <xsl:apply-templates select="item" mode="sitemap">
      <xsl:with-param name="path" select="$path"/>
      <xsl:with-param name="srcpath" select="$srcpath"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="item[@directory]" mode="sitemap">
    <xsl:param name="path"/>
    <xsl:param name="srcpath"/>

    <xsl:if test="not(@sitemap = 'no')">
      <url>
	<loc>
	  <xsl:value-of select="concat($path, @directory, '/', file, '.html')"/>
	</loc>
	<xsl:apply-templates mode="urldetail" select="."/>
	<xsl:apply-templates mode="getdate"
	  select="document(concat($srcpath, @directory, '/', file, '.xml'))"/>
      </url>
    </xsl:if>

    <xsl:apply-templates select="item" mode="sitemap">
      <xsl:with-param name="path" select="concat($path, @directory, '/')"/>
      <xsl:with-param name="srcpath" select="concat($srcpath, @directory, '/')"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="item" mode="urldetail">
    <changefreq>
      <xsl:choose>
        <xsl:when test="@changefreq">
          <xsl:value-of select="@changefreq"/>
        </xsl:when>
        <xsl:otherwise>monthly</xsl:otherwise>
      </xsl:choose>
    </changefreq>

    <priority>
      <xsl:choose>
        <xsl:when test="@priority">
          <xsl:value-of select="@priority"/>
        </xsl:when>
        <xsl:otherwise>0.5</xsl:otherwise>
      </xsl:choose>
    </priority>

  </xsl:template>

  <xsl:template match="sitepage" mode="getdate">
    <xsl:choose>
      <xsl:when test="starts-with(lastmod, '$LastChangedDate: ')">
        <lastmod>
          <xsl:value-of
	    select="substring-before(substring-after(lastmod, '$LastChangedDate: '), ' ')"/>
        </lastmod>
      </xsl:when>

      <xsl:when test="starts-with(lastmod, 'LastChangedDate: ')">
        <lastmod>
          <xsl:value-of
	    select="substring-before(substring-after(lastmod, 'LastChangedDate: '), ' ')"/>
        </lastmod>
      </xsl:when>

      <xsl:when test="lastmod">
	<lastmod><xsl:value-of select="lastmod/text()"/></lastmod>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
