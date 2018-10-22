<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Declare Parameters -->
    <xsl:param name="TargetApp"/>

    <!-- Declare Output -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <!-- Declare Identity -->
    <xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

    <!-- Replace MSH.5.1 and MSH.6.1 with $TargetApp -->
    <xsl:template match="//MSH.5.1>">
        <MSH.5.1>LAB D</MSH.5.1>
    </xsl:template>

</xsl:stylesheet>    