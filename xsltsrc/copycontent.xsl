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
  <!-- Use identity transform rather than copy-of to:
       * set namespace in xslt
       * perform import
  -->
  <xsl:template match="import" mode="copy">
    <xsl:apply-templates mode="copy" select="document(@href)/*"/>
  </xsl:template>

  <xsl:template match="node()" mode="copy">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="copy" select="@*|node()|text()|comment()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table|tbody" mode="copy">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="copy" select="@*|node()|text()|comment()"/>
      <xsl:apply-templates mode="copytr" select="tr"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr" mode="copy"/>

  <xsl:template match="tr" mode="copytr">
    <tr>
      <xsl:if test="not(@class)">
        <xsl:attribute name="class">
          <xsl:value-of select="concat('row', (position() + 1) mod 2)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="copy" select="@*|node()|text()|comment()"/>
    </tr>
    <xsl:text>
    </xsl:text>
  </xsl:template>

  <xsl:template match="@*|text()|comment()" priority="3" mode="copy">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
