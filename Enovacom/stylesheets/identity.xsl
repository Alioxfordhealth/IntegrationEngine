<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
