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
	page	    The active page, e.g. 'Esterel/Backhoe'
	dirs	    node sequence of @directory attributes
  -->
  <xsl:template mode="makenav" match="sitetree">
    <xsl:param name="rootname"/>
    <xsl:param name="page"/>
    <xsl:param name="dirs"/>
    <xsl:param name="linkroot"/>

    <div xmlns="http://www.w3.org/1999/xhtml" class="container-fluid">
      <h2 style="display: none">Navigation Links</h2>
      <ul class="tp-nav nav navbar-nav">
        <li class="nav-item dropdown">
          <a class="dropdown-toggle nav-link"
             data-toggle="dropdown"
             role="button"
             aria-haspopup="true"
             aria-expanded="false">
            <xsl:apply-templates select="item[@homelink = 'yes']"
                                 mode="siblinghref">
              <xsl:with-param name="path" select="$page"/>
              <xsl:with-param name="rpath">
                <xsl:apply-templates select="$dirs"/>
              </xsl:with-param>
              <xsl:with-param name="linkroot" select="$linkroot"/>
            </xsl:apply-templates>
            <xsl:value-of select="$rootname"/>
          </a>
          <div class="dropdown-menu">
            <xsl:apply-templates select="item[not(@inmenu = 'no')]"
                                 mode="siblingitem">
              <xsl:with-param name="path" select="$page"/>
              <xsl:with-param name="rpath">
                <xsl:apply-templates select="$dirs"/>
              </xsl:with-param>
              <xsl:with-param name="linkroot" select="$linkroot"/>
            </xsl:apply-templates>
          </div>
        </li>
        <xsl:apply-templates select="item[not(@inmenu = 'no')]" mode="trailitem">
          <xsl:with-param name="path" select="$page"/>
          <xsl:with-param name="rpath">
            <xsl:apply-templates select="$dirs"/>
          </xsl:with-param>
          <xsl:with-param name="linkroot" select="$linkroot"/>
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="item" mode="trailitem">
    <xsl:param name="path"/>
    <xsl:param name="rpath"/>
    <xsl:param name="linkroot"/>

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

    <xsl:choose>
      <!-- no name, pass through -->
      <xsl:when test="not(name)">
        <xsl:apply-templates select="./item" mode="trailitem">
          <xsl:with-param name="path" select="$path"/>
          <xsl:with-param name="rpath" select="$rpath"/>
	  <xsl:with-param name="linkroot" select="$linkroot"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- item found -->
      <xsl:when test="name=$path and count(./item[not(@inmenu = 'no')]) &gt; 0">
        <li class="nav-item">/</li>
        <li class="nav-item dropdown">
          <a class="button dropdown-toggle nav-link"
             href="#"
             data-toggle="dropdown"
             role="button"
             aria-haspopup="true"
             aria-expanded="false">
          <xsl:value-of select="name"/>
          </a>
          <div class="dropdown-menu">
            <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
                                 mode="siblingitem">
              <xsl:with-param name="path" select="$path"/>
              <xsl:with-param name="rpath" select="$nrpath"/>
              <xsl:with-param name="linkroot" select="$linkroot"/>
            </xsl:apply-templates>
          </div>
        </li>
      </xsl:when>

      <xsl:when test="name=$path and count(./item[not(@inmenu = 'no')]) = 0">
        <li class="nav-item">/</li>
        <li class="nav-item active">
          <xsl:value-of select="name"/>
        </li>
      </xsl:when>

      <!-- item on path -->
      <xsl:when test="name=substring-before($path,'/')
                      and count(./item[not(@inmenu = 'no')]) &gt; 1">
        <li class="nav-item">/</li>
        <li class="nav-item dropdown">
          <a href="#" class="dropdown-toggle nav-link"
                      data-toggle="dropdown"
                      role="button"
                      aria-haspopup="true"
                      aria-expanded="false">
            <xsl:choose>
              <xsl:when test="file">
                <xsl:apply-templates mode="makehref" select="file">
                  <xsl:with-param name="path"
                                  select="concat($linkroot, $nrpath)"/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href">#</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="name"/>
          </a>
          <div class="dropdown-menu">
            <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
                                 mode="siblingitem">
              <xsl:with-param name="path" select="$path"/>
              <xsl:with-param name="rpath" select="$nrpath"/>
              <xsl:with-param name="linkroot" select="$linkroot"/>
            </xsl:apply-templates>
          </div>
        </li>
        <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
                             mode="trailitem">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
          <xsl:with-param name="rpath" select="$nrpath"/>
          <xsl:with-param name="linkroot" select="$linkroot"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:when test="name=substring-before($path,'/')
                      and count(./item[not(@inmenu = 'no')]) &lt;= 1">
        <li class="nav-item">/</li>
        <li class="nav-item active">
          <xsl:value-of select="name"/>
        </li>
        <xsl:apply-templates select="./item[not(@inmenu = 'no')]"
                             mode="trailitem">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
          <xsl:with-param name="rpath" select="$nrpath"/>
          <xsl:with-param name="linkroot" select="$linkroot"/>
        </xsl:apply-templates>
      </xsl:when>

    </xsl:choose>
  </xsl:template>

  <xsl:template match="@directory">
    <xsl:text>../</xsl:text>
  </xsl:template>

  <!-- dropdown menu of siblings -->
  <xsl:template match="item" mode="siblingitem">
    <xsl:param name="path"/>
    <xsl:param name="rpath"/>
    <xsl:param name="linkroot"/>
    <xsl:element name="a">
      <xsl:attribute name="class"
        >dropdown-item button<xsl:if test="@homelink = 'yes'"
          > tp-navbar-home</xsl:if>
      </xsl:attribute>
      <xsl:if test="file">
          <xsl:choose>
            <xsl:when test="@directory">
              <xsl:apply-templates mode="makehref" select="file">
                <xsl:with-param name="path"
                                select="concat($linkroot, $rpath,
                                               @directory, '/')"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="makehref" select="file">
                <xsl:with-param name="path"
                                select="concat($linkroot, $rpath)"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:if>
      <xsl:value-of select="name"/>
    </xsl:element>
  </xsl:template>

  <!-- href attribute to sibling -->
  <xsl:template match="item" mode="siblinghref">
    <xsl:param name="path"/>
    <xsl:param name="rpath"/>
    <xsl:param name="linkroot"/>
    <xsl:if test="file">
        <xsl:choose>
          <xsl:when test="@directory">
            <xsl:apply-templates mode="makehref" select="file">
              <xsl:with-param name="path"
                              select="concat($linkroot, $rpath,
                                             @directory, '/')"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="makehref" select="file">
              <xsl:with-param name="path"
                              select="concat($linkroot, $rpath)"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
