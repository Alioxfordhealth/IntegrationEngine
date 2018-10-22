<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Parameters -->
	<xsl:param name="Gender"/>
	<xsl:param name="PointOfCare"/>
	
	
	<!-- Output Encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Replace Gender with MR (hardcoded) -->
	<!-- 1st method -->
	<xsl:template match="//PID.6.5">
		<PID.6.5>MR</PID.6.5>
	</xsl:template>
	
	<!-- 2nd method -->
	<xsl:template match="//PID.6.5/text()">MR</xsl:template>
	
	<!-- 3d method replaces gender with a parameter passed through XSL -->
	<xsl:template match="//PID.6.5/text()"><xsl:value-of select="$Gender"/></xsl:template>
	
	<!-- 4th method -->
	<xsl:template match="//PID.6.5">
		<PID.6.5><xsl:value-of select="$Gender"/></PID.6.5>
	</xsl:template>
	

	<!-- Replace MSH.5.1 by MSH.6.1	-->
	<xsl:variable name="myVariable" select="//MSH.5.1/text()"/>
	
	<xsl:template match="//MSH.6.1/text()">
		<xsl:value-of select="$myVariable"/>
	</xsl:template>
	
	
	<!-- CONDITIONS: If content of PV1.3.1 is equal to "R" then change value, else do not change -->

	<!-- 1st method -->

	<xsl:template match="//PV1.3.1/text()">

		<xsl:if test=".='R'">TEST</xsl:if>
		
		<xsl:if test=".!='R'"><xsl:value-of select="."/></xsl:if>
	
	</xsl:template>

	<!--2nd method -->
	<xsl:template match="//PD1.3.1[.='R']/text()">TEST</xsl:template>
	
	
	
	<!-- DELETE remove second occurence of PV1.8.1 (content)-->
	<xsl:template match="//PV1.8.1[2]/text()">
	</xsl:template>
	
	<!-- DELETE remove second occurence of PV1.8.1 (everything) -->
	<xsl:template match="//PV1.8.1[2]">
	</xsl:template>
	
	<!-- DELETE remove all PV1 segment -->
	<xsl:template match="//PV1">
	</xsl:template>
	
	
	<!-- INSERTION: no insert function, insert a constant into PID.5.1, and being sure PID.6.1 exists -->
	<xsl:template match="//PID.5.1"></xsl:template>
	<xsl:template match="//PID.6.1">
		<PID.5.1>CONSTANT</PID.5.1>
		<PID.6.1><xsl:value-of select="./text()"/></PID.6.1>
	</xsl:template>
	
</xsl:stylesheet>