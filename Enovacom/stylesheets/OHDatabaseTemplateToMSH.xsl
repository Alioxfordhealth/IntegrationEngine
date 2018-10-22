<!--  Stylesheet declaration  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--  Output encoding  -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

<xsl:param name="NHSOrganisationCode"/>
<xsl:param name="SequenceNumber"/>

 <!-- Root template -->
<xsl:template match="/">
	<MSH>
		<MSH.2.1>^~\&amp;</MSH.2.1>
		<MSH.3.1><xsl:value-of select="$NHSOrganisationCode"/></MSH.3.1>
		<MSH.4.1><xsl:value-of select="//UpdatedSourceSystem/text()"/></MSH.4.1>
		<MSH.5.1>ROUTE</MSH.5.1>
		<MSH.6.1>ROUTE</MSH.6.1>
		<MSH.7.1><xsl:value-of select="//UpdatedDttm/text()"/></MSH.7.1>
		<MSH.8.1/>
		<MSH.9.1>ADT</MSH.9.1>
		<MSH.9.2><xsl:value-of select="//UpdatedEventCode/text()"/></MSH.9.2>
		<MSH.9.3>ADT_A05</MSH.9.3>
		<MSH.10.1><xsl:value-of select="$SequenceNumber"/></MSH.10.1>
		<MSH.11.1>P</MSH.11.1>
		<MSH.12.1>2.4</MSH.12.1>
		<MSH.13.1/>
		<MSH.14.1/>
		<MSH.15.1/>
		<MSH.16.1/>
		<MSH.17.1>GBR</MSH.17.1>
		<MSH.18.1>ASCII</MSH.18.1>
		<MSH.19.1>EN</MSH.19.1>
		<MSH.20.1/>
		<MSH.21.1>ITKv1.0</MSH.21.1>
	</MSH>
</xsl:template>

</xsl:stylesheet>