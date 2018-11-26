<!--  Stylesheet declaration  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--  Output encoding  -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

 <!-- Root template -->
<xsl:template match="/">
	<phoneRoot>
		<PID.13.1><xsl:value-of select="concat(substring(//PID.13.1/text() ,1 ,4 ),' ',substring(//PID.13.1/text() ,5 ,3),' ',substring(//PID.13.1/text() ,8 ,4))"/></PID.13.1>
		<PID.13.2><xsl:value-of select="//PID.13.2/text()"/></PID.13.2>
		<PID.13.3><xsl:value-of select="//PID.13.3/text()"/></PID.13.3>
		<PID.13.4><xsl:value-of select="//PID.13.4/text()"/></PID.13.4>
		<PID.13.5/>
	</phoneRoot>
</xsl:template>

</xsl:stylesheet>