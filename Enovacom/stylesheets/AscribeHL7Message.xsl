<!--   Stylesheet declaration   -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <!--   Output encoding   -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
 <!--  Root template  -->
<xsl:template match="/">
<root>
<MSH>
<MSH.2.1>^~\&amp;</MSH.2.1>
<MSH.3.1><xsl:value-of select="//MSH/MSH.3.1/text()"/></MSH.3.1>
<MSH.4.1><xsl:value-of select="//MSH/MSH.4.1/text()"/></MSH.4.1>
<MSH.5.1>ASCRIBE</MSH.5.1>
<MSH.6.1>ASCRIBE</MSH.6.1>
<MSH.7.1><xsl:value-of select="//MSH/MSH.7.1/text()"/></MSH.7.1>
<MSH.8.1/>
<MSH.9.1>ADT</MSH.9.1>
<MSH.9.2><xsl:value-of select="//MSH/MSH.9.2/text()"/></MSH.9.2>
<MSH.9.3><xsl:value-of select="//MSH/MSH.9.3/text()"/></MSH.9.3>
<MSH.10.1><xsl:value-of select="//MSH/MSH.10.1/text()"/></MSH.10.1>
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
<EVN>
<EVN.1.1/>
<EVN.2.1><xsl:value-of select="//EVN/EVN.2.1/text()"/></EVN.2.1>
<EVN.3.1/>
<EVN.4.1/>
<EVN.5.1/>
<EVN.6.1><xsl:value-of select="//EVN/EVN.6.1/text()"/></EVN.6.1>
<EVN.7.1/>
</EVN>
<PID>
<PID.1.1>1</PID.1.1>
<PID.2.1/>
<PID.3.1><xsl:value-of select="//PID/PID.3.1/text()"/></PID.3.1>
<PID.3.2/>
<PID.3.3/>
<PID.3.4><xsl:value-of select="//PID/PID.3.4/text()"/></PID.3.4>
<PID.4.1/>
<PID.4.2/>
<PID.4.3/>
<PID.4.4/>
<PID.5.1><xsl:value-of select="//PID/PID.5.1/text()"/></PID.5.1>
<PID.5.2><xsl:value-of select="//PID/PID.5.2/text()"/></PID.5.2>
<PID.5.3/>
<PID.5.4/>
<PID.5.5/>
<PID.5.6/>
<PID.5.7>L</PID.5.7>
<PID.6.1/>
<PID.6.2/>
<PID.6.3/>
<PID.6.4/>
<PID.6.5/>
<PID.6.6/>
<PID.6.7/>
<PID.7.1><xsl:value-of select="//PID/PID.7.1/text()"/></PID.7.1>
<PID.8.1><xsl:value-of select="//PID/PID.8.1/text()"/></PID.8.1>
<PID.9.1/>
<PID.10.1/>
<PID.11.1><xsl:value-of select="//PID/PID.11.1/text()"/></PID.11.1>
<PID.11.2><xsl:value-of select="//PID/PID.11.2/text()"/></PID.11.2>
<PID.11.3><xsl:value-of select="//PID/PID.11.3/text()"/></PID.11.3>
<PID.11.4><xsl:value-of select="//PID/PID.11.4/text()"/></PID.11.4>
<PID.11.5><xsl:value-of select="//PID/PID.11.5/text()"/></PID.11.5>
<PID.11.6/>
<PID.11.7>H</PID.11.7>
<PID.12.1/>
<PID.14.1/>
<PID.15.1>EN</PID.15.1>
<PID.16.1>N</PID.16.1>
<PID.17.1>L2</PID.17.1>
<PID.18.1/>
<PID.19.1/>
<PID.20.1/>
<PID.21.1/>
<PID.22.1>A</PID.22.1>
<PID.23.1/>
<PID.24.1/>
<PID.25.1/>
<PID.26.1/>
<PID.27.1/>
<PID.28.1/>
<PID.29.1><xsl:value-of select="//PID/PID.29.1/text()"/></PID.29.1>
<PID.30.1><xsl:value-of select="//PID/PID.30.1/text()"/></PID.30.1>
<PID.31.1/>
<PID.32.1/>
<PID.33.1/>
<PID.34.1/>
<PID.35.1/>
<PID.36.1/>
<PID.37.1/>
<PID.38.1/>
</PID>
<PD1>
<PD1.1.1/>
<PD1.2.1/>
<PD1.3.1><xsl:value-of select="//PD1/PD1.3.1/text()"/></PD1.3.1>
<PD1.3.2/>
<PD1.3.3><xsl:value-of select="//PD1/PD1.3.3/text()"/></PD1.3.3>
<PD1.4.1><xsl:value-of select="//PD1/PD1.4.1/text()"/></PD1.4.1>
<PD1.4.2><xsl:value-of select="//PD1/PD1.4.2/text()"/></PD1.4.2>
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
</root>
</xsl:template>
</xsl:stylesheet>