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
		version="1.0">

  <xsl:include href="makemisc.xsl"/>

  <xsl:template mode="backlink" match="item|sitetree">
    <xsl:param name="relpath" />
    <xsl:param name="match"/>

    <xsl:choose>

      <xsl:when test="$match = 'style' and ./style">
	<xsl:for-each select="style">
          <xsl:element name="link">
            <xsl:attribute name="rel">stylesheet</xsl:attribute>
	    <xsl:if test="@media">
	      <xsl:attribute name="media">
		<xsl:value-of select="@media"/>
	      </xsl:attribute>
	    </xsl:if>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($relpath, text())"/>
            </xsl:attribute>
            <xsl:attribute name="type">text/css</xsl:attribute>
          </xsl:element>
	</xsl:for-each>
      </xsl:when>

      <xsl:when test="$match = 'icon' and icon">
        <xsl:element name="link">
          <xsl:attribute name="rel">shortcut icon</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat($relpath, icon/text())"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>

      <xsl:when test="$match = 'home' and */@homelink = 'yes'">
        <xsl:element name="link">
          <xsl:attribute name="rel">home</xsl:attribute>
          <xsl:attribute name="title">Home</xsl:attribute>

	  <xsl:apply-templates mode="makehref"
			       select="item[@homelink='yes']/file">
	    <xsl:with-param name="path" select="$relpath"/>
	  </xsl:apply-templates>
        </xsl:element>
      </xsl:when>

      <xsl:when test="@directory">
        <xsl:apply-templates mode="backlink" select="..">
          <xsl:with-param name="relpath" select="concat($relpath, '../')"/>
          <xsl:with-param name="match" select="$match"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:when test="not(local-name(.) = 'sitetree')">
        <xsl:apply-templates mode="backlink" select="..">
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="match" select="$match"/>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="makerel" match="item">
    <xsl:variable name="relpath" select="file/@rellinkprefix"/>

    <xsl:apply-templates mode="backlink" select=".">
      <xsl:with-param name="match" select="'home'"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./preceding-sibling::item[not(@inmenu='no')])[1]">
      <xsl:with-param name="rellink">first</xsl:with-param>

      <xsl:with-param name="goback">
        <xsl:choose>
	  <xsl:when test="@directory">
	    <xsl:value-of select="concat($relpath, '../')"/>
	  </xsl:when>
          <xsl:otherwise>
	    <xsl:value-of select="$relpath"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./preceding-sibling::item[not(@inmenu='no')])[last()]">
      <xsl:with-param name="rellink">prev</xsl:with-param>

      <xsl:with-param name="goback">
        <xsl:choose>
	  <xsl:when test="@directory">
	    <xsl:value-of select="concat($relpath, '../')"/>
	  </xsl:when>
          <xsl:otherwise>
	    <xsl:value-of select="$relpath"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./following-sibling::item[not(@inmenu='no')])[last()]">
      <xsl:with-param name="rellink">last</xsl:with-param>

      <xsl:with-param name="goback">
        <xsl:choose>
	  <xsl:when test="@directory">
	    <xsl:value-of select="concat($relpath, '../')"/>
	  </xsl:when>
          <xsl:otherwise>
	    <xsl:value-of select="$relpath"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./following-sibling::item[not(@inmenu='no')])[1]">
      <xsl:with-param name="rellink">next</xsl:with-param>

      <xsl:with-param name="goback">
        <xsl:choose>
	  <xsl:when test="@directory">
	    <xsl:value-of select="concat($relpath, '../')"/>
	  </xsl:when>
          <xsl:otherwise>
	    <xsl:value-of select="$relpath"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makeuplink"
			 select="./parent::item">
      <xsl:with-param name="goback">
        <xsl:choose>
	  <xsl:when test="@directory">
	    <xsl:value-of select="concat($relpath, '../')"/>
	  </xsl:when>
          <xsl:otherwise>
	    <xsl:value-of select="$relpath"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/author)[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='contents'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='copyright'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='glossary'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='help'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='search'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>

    <xsl:apply-templates mode="makelink"
			 select="(./ancestor-or-self::*/link[@rel='index'])[last()]">
      <xsl:with-param name="goback" select="$relpath"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- link rel tags -->
  <xsl:template mode="makelink" match="item">
    <xsl:param name="rellink"/>

    <!-- 'home', 'next', 'prev', ... -->
    <xsl:param name="goback"/>

    <!-- '../'* -->
    <xsl:element name="link">
      <xsl:attribute name="rel">
        <xsl:value-of select="$rellink"/>
      </xsl:attribute>

      <xsl:attribute name="title">
        <xsl:value-of select="name/text()"/>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="@directory">
	  <xsl:apply-templates mode="makehref" select="file">
	    <xsl:with-param name="path"
			    select="concat($goback, @directory, '/')"/>
	  </xsl:apply-templates>
        </xsl:when>

        <xsl:otherwise>
	  <xsl:apply-templates mode="makehref" select="file">
	    <xsl:with-param name="path" select="$goback"/>
	  </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>

  </xsl:template>

  <xsl:template mode="makelink" match="author">

    <xsl:element name="link">
      <xsl:attribute name="rel">author</xsl:attribute>

      <xsl:attribute name="title">
        <xsl:value-of select="text()"/>
      </xsl:attribute>

      <xsl:attribute name="href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
    </xsl:element>

  </xsl:template>

  <xsl:template mode="makelink" match="link">
    <xsl:element name="link">

      <xsl:attribute name="rel">
        <xsl:value-of select="@rel"/>
      </xsl:attribute>

      <xsl:attribute name="href">
        <xsl:value-of select="text()"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template mode="makeuplink" match="item">
    <xsl:param name="goback"/>
    <!-- '../'* -->

    <xsl:element name="link">
      <xsl:attribute name="rel">up</xsl:attribute>

      <xsl:attribute name="title">
        <xsl:value-of select="name/text()"/>
      </xsl:attribute>

      <xsl:apply-templates mode="makehref" select="file">
        <xsl:with-param name="path" select="$goback"/>
      </xsl:apply-templates>
    </xsl:element>

  </xsl:template>

  <xsl:template match="keyword">
    <xsl:value-of select="text()"/>

    <xsl:if test="not(position() = last())">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
