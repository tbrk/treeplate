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

  <xsl:template mode="makepath" match="item">
    <xsl:value-of select="name"/>
    <xsl:if test="position() != last()">/</xsl:if>
  </xsl:template>

  <xsl:template mode="makepath" match="@directory">
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">/</xsl:if>
  </xsl:template>

</xsl:stylesheet>
