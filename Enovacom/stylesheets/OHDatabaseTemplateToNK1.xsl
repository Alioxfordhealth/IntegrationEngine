<!--  Stylesheet declaration  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--  Output encoding  -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

 <!-- Root template -->
<xsl:template match="/">
	<NK1>
		<NK1.1.1><xsl:value-of select="//Iterator/text()"/></NK1.1.1>
		<NK1.2.1><xsl:value-of select="//Surname/text()"/></NK1.2.1>
		<NK1.2.2><xsl:value-of select="//Forename/text()"/></NK1.2.2>
		<NK1.2.3/>
		<NK1.2.4/>
		<NK1.2.5/>
		<NK1.2.6/>
		<NK1.2.7>L</NK1.2.7>
		<NK1.3.1><xsl:value-of select="//Relationship/text()"/></NK1.3.1>	
		<NK1.4.1><xsl:value-of select="//Address1/text()"/></NK1.4.1>
		<NK1.4.2><xsl:value-of select="//Address2/text()"/></NK1.4.2>
		<NK1.4.3><xsl:value-of select="//Address3/text()"/></NK1.4.3>
		<NK1.4.4><xsl:value-of select="//Address4/text()"/></NK1.4.4>
		<NK1.4.5><xsl:value-of select="//Postcode/text()"/></NK1.4.5>
		<NK1.4.6></NK1.4.6>
		<NK1.4.7></NK1.4.7>
		<NK1.5.1><xsl:value-of select="//TelephoneNumber/text()"/></NK1.5.1>
		<NK1.5.2><xsl:value-of select="//TelephoneUseCode/text()"/></NK1.5.2>
		<NK1.5.3><xsl:value-of select="//TelephoneType/text()"/></NK1.5.3>
		<NK1.5.4/>
		<NK1.6.1/>
		<NK1.6.2/>
		<NK1.6.3/>
		<NK1.6.4/>
		<NK1.7.1>Next of Kin</NK1.7.1>
		<NK1.8.1><xsl:value-of select="//StartDate/text()"/></NK1.8.1>
		<NK1.9.1><xsl:value-of select="//EndDate/text()"/></NK1.9.1>
		<NK1.10.1/>
		<NK1.11.1/>
		<NK1.12.1/>
		<NK1.13.1/>
		<NK1.14.1/>
		<NK1.15.1><xsl:value-of select="//Gender/text()"/></NK1.15.1>
		<NK1.16.1><xsl:value-of select="//DateOfBirth/text()"/></NK1.16.1>
		<NK1.17.1/>
		<NK1.18.1/>
		<NK1.19.1/>
		<NK1.20.1><xsl:value-of select="//PrimaryLanguage/text()"/></NK1.20.1>
		<NK1.21.1/>
		<NK1.22.1/>
		<NK1.23.1/>
		<NK1.24.1/>
		<NK1.25.1/>
		<NK1.26.1/>
		<NK1.27.1/>
		<NK1.28.1/>
		<NK1.29.1/>
		<NK1.30.1/>
		<NK1.31.1/>
		<NK1.32.1/>
		<NK1.33.1/>
		<NK1.34.1/>
		<NK1.35.1/>
		<NK1.36.1/>
		<NK1.37.1/>
	</NK1>
</xsl:template>

</xsl:stylesheet>