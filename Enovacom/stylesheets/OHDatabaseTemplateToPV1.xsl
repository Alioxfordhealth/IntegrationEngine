<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!-- Output encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="/">
                <PV1>
                <PV1.1.1/>
                <PV1.2.1><xsl:value-of select="//EpisodeType/text()"/></PV1.2.1> <!--From tblEpisodeTypeValues 3 IP, 1, 2, 5 - OP-->
                <PV1.3.1><xsl:value-of select="//WardLocationID/text()"/></PV1.3.1> <!-- need a mapping table, optional? -->
                <PV1.4.1><xsl:value-of select="//Episode_Priority_ID/text()"/></PV1.4.1> <!-- Episode_Priority_ID links to tblEpisodePriorityValues-->
                <PV1.5.1/> 
                <PV1.6.1/> 
                <PV1.7.1/> 
                <PV1.8.1><xsl:value-of select="//GP_Code/text()"/></PV1.8.1> <!--GP_ID links to tblGP-->
                <PV1.9.1><xsl:value-of select="//consulting_GMC_Code/text()"/></PV1.9.1> <!--tblTeamMember with Team_Member_Role_ID = 0 (Consultant)-->
                <PV1.9.2><xsl:value-of select="//consulting_Surname/text()"/></PV1.9.2> <!--tblTeamMember with Team_Member_Role_ID = 0 (Consultant)-->
                <PV1.9.3><xsl:value-of select="//consulting_Forename/text()"/></PV1.9.3> <!--tblTeamMember with Team_Member_Role_ID = 0 (Consultant)-->
                <PV1.10.1/> <!-- not supported-->
                <PV1.11.1/><!-- not supported-->
                <PV1.12.1/><!-- not supported-->
                <PV1.13.1/><!-- not supported-->
                <PV1.14.1><xsl:value-of select="//Referral_Source_ID/text()"/></PV1.14.1> <!-- need a mapping table, tblEpisode Referral_Source_ID links to tblReferralSourceValues-->
                <PV1.15.1/><!-- not supported-->
                <PV1.16.1/><!-- not supported-->
                <PV1.17.1><xsl:value-of select="//admitting_GMC_Code/text()"/></PV1.17.1> <!-- tblEpisode Accepted_By_Staff_ID links to tblStaff Consultant_GMC_Code-->
                <PV1.17.2><xsl:value-of select="//admitting_Surname/text()"/></PV1.17.2><!-- tblEpisode Accepted_By_Staff_ID links to tblStaff Surname-->
                <PV1.17.3><xsl:value-of select="//admitting_Forename/text()"/></PV1.17.3><!-- tblEpisode Accepted_By_Staff_ID links to tblStaff Forename-->
                <PV1.18.1/> <!--not supported by CN-->
                <PV1.19.1><xsl:value-of select="//Episode_ID/text()"/></PV1.19.1> <!--NHS number?-->
                <PV1.20.1/>
                <PV1.21.1/>
                <PV1.22.1/>
                <PV1.23.1/>
                <PV1.24.1/>
                <PV1.25.1/>
                <PV1.26.1/>
                <PV1.27.1/>
                <PV1.28.1/>
                <PV1.29.1/>
                <PV1.30.1/>
                <PV1.31.1/>
                <PV1.32.1/>
                <PV1.33.1/>
                <PV1.34.1/>
                <PV1.35.1/>
                <PV1.36.1><xsl:value-of select="//Discharge_Method_Episode_ID/text()"/></PV1.36.1><!--Discharge_Method_Episode_ID links to tblDischargeMethodEpisodeValues-->
                <PV1.37.1><xsl:value-of select="//Discharge_Destination_ID/text()"/></PV1.37.1><!-- Discharge_Destination_ID links to tblDischargeDestinationValues-->
                <PV1.38.1/>
                <PV1.39.1/>
                <PV1.40.1/>
                <PV1.41.1/>
                <PV1.42.1/>
                <PV1.43.1/>
                <PV1.44.1><xsl:value-of select="//pvStart/text()"/></PV1.44.1> <!--For IP look at ward stay Actual_Start_Date + Actual_Start_Time, for OP tblEpisode Start_Date -->
                <PV1.45.1><xsl:value-of select="//pvEnd/text()"/></PV1.45.1> <!-- For IP look at ward stay Actual_End_Date + Actual_End_Time, for OP tblEpisode Discharge_Date + Doscharge_Time-->
                <PV1.46.1/>
                <PV1.47.1/>
                <PV1.48.1/>
                <PV1.49.1/>
                <PV1.50.1/>
                <PV1.51.1/>
                <PV1.52.1/>
                </PV1>
	</xsl:template>
	
</xsl:stylesheet>
