<?xml version="1.0"?>
<!-- Copyright (c) 2016 Timothy Bourke. All rights reserved.
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
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <!-- string params:
        rooturl     the value of sitetree/rooturl
	page	    The active page, e.g. 'Esterel/Backhoe'
  -->
  <xsl:template mode="makecrumbs" match="sitetree">
    <xsl:param name="rooturl"/>
    <xsl:param name="page"/>

    <script type="application/ld+json">
    {
    "@context": "http://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
      <xsl:apply-templates select="item[not(@inmenu = 'no')]"
                           mode="crumbitem">
          <xsl:with-param name="path" select="$page"/>
          <xsl:with-param name="lpath" select="concat($rooturl, '/')"/>
          <xsl:with-param name="level" select="1"/>
        </xsl:apply-templates>
    ]}
    </script>
  </xsl:template>

  <xsl:template match="item" mode="crumbitem">
    <xsl:param name="path"/>
    <xsl:param name="lpath"/>
    <xsl:param name="level"/>

    <xsl:variable name="nextlpath">
      <xsl:choose>
	<xsl:when test="@directory">
          <xsl:value-of select="concat($lpath, @directory, '/')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$lpath"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="separator">
      <xsl:choose>
	<xsl:when test="name=$path">
          <xsl:value-of select="''"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="','"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!-- no name, pass through -->
      <xsl:when test="not(name)">
        <xsl:apply-templates select="./item" mode="crumbitem">
          <xsl:with-param name="path" select="$path"/>
          <xsl:with-param name="lpath" select="$nextlpath"/>
	  <xsl:with-param name="level" select="$level"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- name with file element -->
      <xsl:when test="(name=substring-before($path,'/') or name=$path) and file">
        {
          "@type": "ListItem",
          "position": <xsl:value-of select="$level"/>,
          "item": {
            "@id": "<xsl:apply-templates mode="maketexthref" select="file">
                     <xsl:with-param name="path" select="$nextlpath"/>
                   </xsl:apply-templates>",
            "name": "<xsl:value-of select="name"/>"
          }
          }<xsl:value-of select="$separator"/>
        <xsl:apply-templates select="./item" mode="crumbitem">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
          <xsl:with-param name="lpath" select="$nextlpath"/>
	  <xsl:with-param name="level" select="$level + 1"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
