<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Parameters -->
	<xsl:param name="TargetSystem"/>
	<xsl:param name="TargetApplication"/>
	<xsl:param name="PIDPrefix"/>
	
	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- 3d method replaces gender with a parameter passed through XSL -->
	<xsl:template match="//MSH.5.1/text()"><xsl:value-of select="$TargetSystem"/></xsl:template>

	<!-- 3d method replaces gender with a parameter passed through XSL -->
	<xsl:template match="//MSH.6.1/text()"><xsl:value-of select="$TargetApplication"/></xsl:template>
	
	<!-- 3d method replaces gender with a parameter passed through XSL -->
	
	<xsl:variable name="PIDPrefixmyVariable" select="$PIDPrefix"/>
	
	<xsl:template match="//PID.3.1/text()"><xsl:value-of select="concat($PIDPrefix,//PID.3.1/text())"/></xsl:template>
	
	<xsl:template match="//PID.5.1/text()"><xsl:value-of select="substring(//PID.5.1/text(),0,4)"/></xsl:template>
	
	<!-- INSERTION: no insert function, insert a constant into PID.5.1, and being sure PID.6.1 exists -->
	<xsl:template match="//MSH.13.1"></xsl:template>
	<xsl:template match="//MSH.17.1">
		<MSH.13.1>FATHI</MSH.13.1>
		<MSH.17.1><xsl:value-of select="./text()"/></MSH.17.1>
	</xsl:template>
	
	<!-- DELETE remove all EVN segment -->
	<xsl:template match="//EVN">
	</xsl:template>
	
</xsl:stylesheet>