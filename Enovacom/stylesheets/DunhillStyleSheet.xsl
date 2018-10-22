<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="Labname"/>

	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
		<xsl:template match="//MSH.6.1">
		<MSH.6.1><xsl:value-of select="$Labname"/></MSH.6.1>
	</xsl:template>
	
	<xsl:template match="//MSH.5.1">
		<MSH.5.1><xsl:value-of select="$Labname"/></MSH.5.1>
	</xsl:template>
	
	<xsl:template match="//EVN">

	</xsl:template>
	
	<xsl:template match="//PID.3.1">
		<PID.3.1><xsl:value-of select="concat('A',./text())"/></PID.3.1>
	</xsl:template>
	
	<xsl:template match="//PID.5.1">
		<PID.5.1><xsl:value-of select="substring(./text(),1,4)"/></PID.5.1>
	</xsl:template>
	
	<xsl:template match="//MSH.12.1">
		<MSH.12.1><xsl:value-of select="./text()"/></MSH.12.1>
		<MSH.13.1>TESTESTEST</MSH.13.1>
	</xsl:template>
	
	
</xsl:stylesheet>
