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
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:exsl="http://exslt.org/common"
		version="1.0"
		extension-element-prefixes="exsl">

  <xsl:output method="text"/>

  <xsl:include href="makepage.xsl"/>
  <xsl:include href="makemap.xsl"/>

  <xsl:template match="hier">
    <xsl:variable name="treemod"
		  select="filehier[@name='src']/file[@name='sitetree.xml']/@lastmod"/>

    <xsl:apply-templates
	select="document(concat(filehier[@name='src']/@path,     '/sitetree.xml'))">
      <xsl:with-param name="srchier" select="filehier[@name='src']"/>
      <xsl:with-param name="dsthier" select="filehier[@name='dst']"/>
      <xsl:with-param name="treemod" select="$treemod"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="sitetree">
    <xsl:param name="srchier"/>
    <xsl:param name="dsthier"/>
    <xsl:param name="treemod"/>

    <xsl:apply-templates select="item" mode="fixpath">
      <xsl:with-param name="csrcitem" select="$srchier"/>
      <xsl:with-param name="csrcpath" select="$srchier/@path"/>
      <xsl:with-param name="cdstitem" select="$dsthier"/>
      <xsl:with-param name="cdstpath" select="$dsthier/@path"/>
      <xsl:with-param name="treemod" select="$treemod"/>
    </xsl:apply-templates>

    <!-- sitemap.xml -->
    <xsl:if test="not($dsthier/file[@name='sitemap.xml']/@lastmod &gt; $treemod)">
      <xsl:message>
        <xsl:text>:::::</xsl:text>
        <xsl:value-of select="concat($dsthier/@path, '/', 'sitemap.xml')"/>
      </xsl:message>

      <exsl:document href="{concat($dsthier/@path, '/', 'sitemap.xml')}"
		     method="xml"
		     encoding="UTF-8"
		     indent="yes">
        <xsl:apply-templates select="." mode="makemap">
          <xsl:with-param name="srcpath">
            <xsl:value-of select="concat($srchier/@path, '/')"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </exsl:document>

    </xsl:if>
  </xsl:template>

  <xsl:template match="item">
    <xsl:param name="csrcitem"/>
    <xsl:param name="csrcpath"/>
    <xsl:param name="cdstitem"/>
    <xsl:param name="cdstpath"/>
    <xsl:param name="treemod"/>

    <xsl:variable name="extension">
      <xsl:choose>
	<xsl:when test="not(current()/file/@extension)">
	  <xsl:text>.html</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('.', current()/file/@extension)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="not($cdstitem/file[@name=concat(current()/file/text(),
						  $extension)]/@lastmod
		  &gt;
		  $csrcitem/file[@name=concat(current()/file/text(), '.xml')]/@lastmod)
		  or
		  not ($cdstitem/file[@name=concat(current()/file/text(),
						   $extension)]/@lastmod
		  &gt; $treemod)">

      <xsl:message>
        <xsl:text>:::::</xsl:text>
        <xsl:value-of select="concat($cdstpath, '/', file/text(), $extension)"/>
      </xsl:message>

      <exsl:document href="{concat($cdstpath, '/', file/text(), $extension)}"
		     method="xml"
		     omit-xml-declaration="yes"
		     standalone="yes"
		     doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		     doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		     indent="yes">
        <xsl:apply-templates select="document(concat($csrcpath, '/', file/text(), '.xml'))">
          <xsl:with-param name="siteitem" select="."/>
        </xsl:apply-templates>
      </exsl:document>
    </xsl:if>

    <xsl:apply-templates select="item" mode="fixpath">
      <xsl:with-param name="csrcitem" select="$csrcitem"/>
      <xsl:with-param name="csrcpath" select="$csrcpath"/>
      <xsl:with-param name="cdstitem" select="$cdstitem"/>
      <xsl:with-param name="cdstpath" select="$cdstpath"/>
      <xsl:with-param name="treemod" select="$treemod"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="item" mode="fixpath">
    <xsl:param name="csrcitem"/>
    <xsl:param name="csrcpath"/>
    <xsl:param name="cdstitem"/>
    <xsl:param name="cdstpath"/>
    <xsl:param name="treemod"/>

    <xsl:choose>

      <xsl:when test="@directory">
        <xsl:apply-templates select=".">
          <xsl:with-param name="csrcitem"
			  select="$csrcitem/dir[@name=current()/@directory]"/>
          <xsl:with-param name="csrcpath"
			  select="concat($csrcpath, '/', @directory)"/>
          <xsl:with-param name="cdstitem"
			  select="$cdstitem/dir[@name=current()/@directory]"/>
          <xsl:with-param name="cdstpath"
			  select="concat($cdstpath, '/', @directory)"/>
          <xsl:with-param name="treemod"
			  select="$treemod"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates select=".">
          <xsl:with-param name="csrcitem" select="$csrcitem"/>
          <xsl:with-param name="csrcpath" select="$csrcpath"/>
          <xsl:with-param name="cdstitem" select="$cdstitem"/>
          <xsl:with-param name="cdstpath" select="$cdstpath"/>
          <xsl:with-param name="treemod" select="$treemod"/>
        </xsl:apply-templates>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
