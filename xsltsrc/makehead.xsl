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

  <xsl:include href="rellinks.xsl"/>

  <xsl:template mode="makehead" match="sitepage">
    <xsl:param name="siteitem"/>
    <title>
      <xsl:if test="not(title/@prefix = 'no')">
        <xsl:for-each select="($siteitem/ancestor-or-self::*/prefix)[last()]">
          <xsl:value-of select="text()"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:value-of select="title"/>
      <xsl:if test="not(title/@suffix = 'no')">
        <xsl:for-each select="($siteitem/ancestor-or-self::*/suffix)[last()]">
          <xsl:value-of select="text()"/>
        </xsl:for-each>
      </xsl:if>
    </title>

    <xsl:apply-templates mode="backlink" select="$siteitem">
      <xsl:with-param name="match" select="'style'"/>
    </xsl:apply-templates>

    <xsl:comment><![CDATA[[if lte IE 7]>
    <style type='text/css'>
	body { overflow: hidden; font-size: 100%; }
	div#container { overflow: auto; }
    </style>
    <script type="text/javascript">onload = function() { container.focus() }</script>
  <![endif]]]></xsl:comment>

    <xsl:apply-templates mode="backlink" select="$siteitem">
      <xsl:with-param name="match" select="'icon'"/>
    </xsl:apply-templates>

    <xsl:element name="meta">
      <xsl:attribute name="name">description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="description"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:apply-templates mode="makerel" select="$siteitem"/>
    <xsl:if test="count($siteitem/ancestor-or-self::*/keyword[not(@inherit='no')] | ./keyword)&gt;0">
      <xsl:element name="meta">
        <xsl:attribute name="name">keywords</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:apply-templates
	    select="$siteitem/ancestor-or-self::*/keyword[not(@inherit='no')] | ./keyword"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <xsl:apply-templates mode="copy" select="header/*"/>
  </xsl:template>

</xsl:stylesheet>
