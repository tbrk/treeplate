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
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <!-- string params:
	page	    The active page, e.g. 'Esterel/Backhoe'
	dirs	    node sequence of @directory attributes
  -->
  <xsl:template mode="makemenu" match="sitetree">
    <xsl:param name="page"/>
    <xsl:param name="dirs"/>

    <div xmlns="http://www.w3.org/1999/xhtml" id="menu">
      <div id="innermenu">
        <h2>Site menu</h2>
        <ul>
          <xsl:apply-templates select="item[not(@inmenu = 'no')]" mode="menuitem">
            <xsl:with-param name="path" select="$page"/>
            <xsl:with-param name="rpath">
              <xsl:apply-templates select="$dirs"/>
            </xsl:with-param>
          </xsl:apply-templates>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="item" mode="menuitem">
    <xsl:param name="path"/>
    <xsl:param name="rpath"/>

    <xsl:choose>
      <!-- no name, pass through -->
      <xsl:when test="not(name)">
        <xsl:apply-templates select="./item" mode="menuitem">
          <xsl:with-param name="path" select="$path"/>
          <xsl:with-param name="rpath" select="$rpath"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- item found -->
      <xsl:when test="name=$path">
        <li>
          <span class="active">
            <xsl:value-of select="name"/>
          </span>
          <xsl:if test="count(./item[not(@inmenu = 'no')])&gt;0">
            <ul>
              <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
				   mode="menuitem">
                <xsl:with-param name="path" select="''"/>
                <xsl:with-param name="rpath">
                  <xsl:value-of select="''"/>
                </xsl:with-param>
              </xsl:apply-templates>
            </ul>
          </xsl:if>
        </li>
      </xsl:when>

      <!-- item on path -->
      <xsl:when test="name=substring-before($path,'/')">
        <xsl:variable name="nrpath">
          <xsl:choose>
            <xsl:when test="@directory">
              <xsl:value-of select="substring-after($rpath,'/')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$rpath"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <li>
          <xsl:choose>
            <xsl:when test="file">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat($nrpath, file, '.html')"/>
                </xsl:attribute>
                <xsl:value-of select="name"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name"/>
            </xsl:otherwise>
          </xsl:choose>
          <ul>
            <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
				 mode="menuitem">
              <xsl:with-param name="path" select="substring-after($path,'/')"/>
              <xsl:with-param name="rpath" select="$nrpath"/>
            </xsl:apply-templates>
          </ul>
        </li>
      </xsl:when>

      <!-- sibling of item on path -->
      <xsl:when test="name">
        <li>
          <xsl:choose>
            <xsl:when test="file">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="@directory">
                      <xsl:value-of
			select="concat($rpath, @directory, '/', file, '.html')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($rpath, file, '.html')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="name"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name"/>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@directory">
    <xsl:text>../</xsl:text>
  </xsl:template>

</xsl:stylesheet>
