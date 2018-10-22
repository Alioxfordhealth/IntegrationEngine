<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="/">
		<EVN>
			<EVN.1.1/>
			<EVN.2.1><xsl:value-of select="//Updated_Dttm/text()"/></EVN.2.1>
			<EVN.3.1/>
			<EVN.4.1/>
			<EVN.5.1>C134325</EVN.5.1>
			<EVN.6.1><xsl:value-of select="//Updated_Dttm/text()"/></EVN.6.1>
			<EVN.7.1/>
		</EVN>
	</xsl:template>
	
</xsl:stylesheet>
