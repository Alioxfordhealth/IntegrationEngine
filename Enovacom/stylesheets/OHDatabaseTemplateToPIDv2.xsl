<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="/">
		<PID>
			<PID.1.1/>
			<PID.2.1/>
			<PID.3.1><xsl:value-of select="//NHSNumber/text()"/></PID.3.1>
			<PID.3.2/>
			<PID.3.3/>
			<PID.3.4>NHS</PID.3.4>
			<PID.4.1/>
			<PID.4.2/>
			<PID.4.3/>
			<PID.4.4/>
			<PID.5.1><xsl:value-of select="//Surname/text()"/></PID.5.1>
			<PID.5.2><xsl:value-of select="//Forename/text()"/></PID.5.2>
			<PID.5.3/>
			<PID.5.4/>
			<PID.5.5><xsl:value-of select="//Title/text()"/></PID.5.5>
			<PID.5.6/>
			<PID.5.7>L</PID.5.7>
			<PID.6.1/>
			<PID.6.2/>
			<PID.6.3/>
			<PID.6.4/>
			<PID.6.5/>
			<PID.6.6/>
			<PID.6.7/>
			<PID.7.1><xsl:value-of select="//DateOfBirth/text()"/></PID.7.1>
			<PID.8.1><xsl:value-of select="//Gender/text()"/></PID.8.1>
			<PID.9.1/>
			<PID.10.1/>
			<PID.11.1><xsl:value-of select="//Address1/text()"/></PID.11.1>
			<PID.11.2><xsl:value-of select="//Address2/text()"/></PID.11.2>
			<PID.11.3><xsl:value-of select="//Address3/text()"/></PID.11.3>
			<PID.11.4><xsl:value-of select="//Address4/text()"/></PID.11.4>
			<PID.11.5><xsl:value-of select="//Postcode/text()"/></PID.11.5>
			<PID.11.6/>
			<PID.11.7><xsl:value-of select="//AddressType/text()"/></PID.11.7>
			<PID.12.1/>
			<PID.13.4><xsl:value-of select="//Email/text()"/></PID.13.4>
			<PID.13.5/>
			<PID.14.1/>
			<PID.15.1><xsl:value-of select="//PrimaryLanguage/text()"/></PID.15.1>
			<PID.16.1><xsl:value-of select="//MaritalStatus/text()"/></PID.16.1>
			<PID.17.1><xsl:value-of select="//Religion/text()"/></PID.17.1>
			<PID.18.1/>
			<PID.19.1/>
			<PID.20.1/>
			<PID.21.1/>
			<PID.22.1><xsl:value-of select="//EthnicGroup/text()"/></PID.22.1>
			<PID.23.1/>
			<PID.24.1/>
			<PID.25.1/>
			<PID.26.1/>
			<PID.27.1/>
			<PID.28.1/>
			<PID.29.1><xsl:value-of select="//DateOfDeath/text()"/></PID.29.1>
			<PID.30.1><xsl:value-of select="//PatientDeathIndicator/text()"/></PID.30.1>
			<PID.31.1/>
			<PID.32.1><xsl:value-of select="//IdentityReliabilityCode/text()"/></PID.32.1>
			<PID.33.1/>
			<PID.34.1/>
			<PID.35.1/>
			<PID.36.1/>
			<PID.37.1/>
			<PID.38.1/>
		</PID>
	</xsl:template>
	
</xsl:stylesheet>
