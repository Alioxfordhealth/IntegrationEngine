<!--  Stylesheet declaration  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--  Output encoding  -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

 <!-- Root template -->
<xsl:template match="/">
	<PD1>
		<PD1.1.1/>
		<PD1.2.1/>
		<PD1.3.1><xsl:value-of select="//PracticeName/text()"/></PD1.3.1>
		<PD1.3.2/>
		<PD1.3.3><xsl:value-of select="//PracticeCode/text()"/></PD1.3.3>
		<PD1.4.1><xsl:value-of select="//GPCode/text()"/></PD1.4.1>
		<PD1.4.2><xsl:value-of select="//GPName/text()"/></PD1.4.2>
		<PD1.4.3/>
		<PD1.4.4/>
		<PD1.4.5/>
		<PD1.4.6/>
		<PD1.5.1/>
		<PD1.6.1/>
		<PD1.7.1/>
		<PD1.8.1/>
		<PD1.9.1/>
		<PD1.10.1/>
		<PD1.11.1/>
		<PD1.12.1/>
		<PD1.13.1/>
		<PD1.14.1/>
		<PD1.15.1/>
		<PD1.16.1/>
		<PD1.17.1/>
		<PD1.18.1/>
		<PD1.19.1/>
		<PD1.20.1/>
		<PD1.21.1/>
	</PD1>
</xsl:template>

</xsl:stylesheet>