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

  <xsl:template match="sitepage" mode="redirect">
    <xsl:param name="siteitem"/>

    <head>
      <title>
        <xsl:value-of select="title"/>
      </title>

      <xsl:apply-templates mode="backlink" select="$siteitem">
        <xsl:with-param name="match" select="'style'"/>
        <xsl:with-param name="rellink" select="$siteitem/file/@rellinkprefix"/>
      </xsl:apply-templates>

      <xsl:apply-templates mode="backlink" select="$siteitem">
        <xsl:with-param name="match" select="'icon'"/>
        <xsl:with-param name="rellink" select="$siteitem/file/@rellinkprefix"/>
      </xsl:apply-templates>

      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>

      <xsl:element name="meta">
        <xsl:attribute name="http-equiv">Refresh</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="concat('0; url=', redirect/@href)"/>
        </xsl:attribute>
      </xsl:element>
    </head>
    <body>
      <p>This page has moved to a
  	<xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:value-of select="redirect/@href"/>
	  </xsl:attribute>
	  <xsl:text>new location</xsl:text>
	</xsl:element>.
      You are being automatically redirected.</p>
    </body>
  </xsl:template>

</xsl:stylesheet>
