<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Parameters -->
  <xsl:param name="Application"/>
  <xsl:param name="Prefix"/>
 
  
  
	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>

       
			<xsl:apply-templates select="@* | node()"/>
      
      
		</xsl:copy>
	</xsl:template>

  <xsl:template match="//MSH.5.1/text()">
    <xsl:value-of select="$Application"/>
  </xsl:template>

  <xsl:template match="//MSH.6.1/text()">
    <xsl:value-of select="$Application"/>
  </xsl:template>

  <xsl:template match="//EVN">
  </xsl:template>

  <xsl:template match="//PID.3.1/text()">
    <xsl:value-of select="concat($Prefix,//PID.3.1/text())"/>

 
    
      </xsl:template>
	
</xsl:stylesheet>


