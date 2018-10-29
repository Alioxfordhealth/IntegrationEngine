<!--  Stylesheet declaration  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--  Output encoding  -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

 <!-- Root template -->
<xsl:template match="/">
	<phoneRoot>
		<PID.13.1><xsl:value-of select="//HomeTelephone/text()"/></PID.13.1>
		<PID.13.2><xsl:value-of select="//PhoneType/text()"/></PID.13.2>
		<PID.13.3><xsl:value-of select="//UseCode/text()"/></PID.13.3>
	</phoneRoot>
</xsl:template>

</xsl:stylesheet>