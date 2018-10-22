<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Parameters -->
	<xsl:param name="MSH.5.1"/>
	<xsl:param name="MSH.6.1"/>
    <xsl:param name="PrefixForPID.3.1"/>

	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

    <!-- Replace MSH.5.1 and MSH.6.1 with a parameter -->

	<xsl:template match="//MSH.5.1/text()"><xsl:value-of select="$MSH.5.1"/></xsl:template>
	<xsl:template match="//MSH.6.1/text()"><xsl:value-of select="$MSH.6.1"/></xsl:template>

    <!-- Removing EVN Segment -->
    <xsl:template match="//EVN"></xsl:template>

    <!-- Adding Parameter Prefix to PID.3.1 -->

    <!-- <xsl:variable name="prefixVariable" select="$PrefixForPID.3.1"/> -->
	<xsl:template match="//PID.3.1/text()"><xsl:value-of select="concat($PrefixForPID.3.1, //PID.3.1/text())"/></xsl:template>
	
    <!-- Changing PID.5.1 to only keep first 4 characters -->
    <xsl:template match="//PID.5.1/text()"><xsl:value-of select="substring(//PID.5.1/text(), 1, 4) "/></xsl:template>

    <!-- Adding MSH.13.1 with random value -->

    <xsl:template match="//MSH.13.1"></xsl:template>
	<xsl:template match="//MSH.12.1">
		<MSH.12.1><xsl:value-of select="./text()"/></MSH.12.1>
        <MSH.13.1>TATJANA</MSH.13.1>
	</xsl:template>

</xsl:stylesheet>
