<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	
	<!-- Output Encoding -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- Copies all the XML elements from the source document (node=tag, @=attribut) -->
	<xsl:template match="/">
		
		<ReportMsg MsgStatus="Live" MsgUrgency="Normal" MsgRcptAckRequest="Always">
			<!--
			 
				Message Header Information, do not use as a permanent reference
				use (AgentsDirectory or Parties) and ClinicalReport sections instead 
				
			-->
			<!--
			 contents of these fields should be completed as per the dtd, these are dummy values only
			-->
			<MsgId>00000001</MsgId>
			<MsgIssueDate><xsl:value-of select="//MsgIssueDate/text()"/></MsgIssueDate>
			<MsgSender><xsl:value-of select="//MsgSender/text()"/></MsgSender>
			<MsgRecipient><xsl:value-of select="//MsgRecipient/text()"/></MsgRecipient>
			<!--  Defines the recipient parties  -->
			<ServiceRequester>
			<!-- Recipient Party eg GP -->	
				<IdValue>1</IdValue>
			</ServiceRequester>
			<!--  Defines the sending parties  -->
			<ServiceProvider>
			<!--  Sending Party eg. Hospital -->
				<IdValue>2</IdValue>
			</ServiceProvider>
			<!--  Patient Matching Info  -->
			<PatientMatchingInfo>
				<!--  Patients NHS or CHI Number  -->
					<PatientId>
						<Id>
							<IdType><xsl:value-of select="//IdType/text()"/></IdType>
							<IdValue><xsl:value-of select="//IdValue/text()"/></IdValue>
						</Id>
					</PatientId>
				<!--  Patients Name  -->
				<PersonName_s>
					<PersonNameType><xsl:value-of select="//PersonNameType/text()"/></PersonNameType>
					<StructPersonName>
						<FamilyName><xsl:value-of select="//Surname/text()"/></FamilyName>
						<GivenName><xsl:value-of select="//Forename/text()"/></GivenName>
					</StructPersonName>
				</PersonName_s>
				<!--  Patients DOB YYYYMMDD -->
				<BirthDate><xsl:value-of select="//Date_Of_Birth/text()"/></BirthDate>
				<!--
				 Patients Sex 		 
						"0" [Unknown]
						 "1" [Male]
						 "2" [Female]
						 "9" [Not specified]
				-->
				<Sex><xsl:value-of select="//Gender_ID/text()"/></Sex>
			</PatientMatchingInfo>
			<!--
			 Parties Element replaces AgentsDirectory in Kettering
			-->
			<Parties>
				<!--  Recipient  -->
				<Party AgentId="1">
					<HcpCode IdType="GP"><xsl:value-of select="//RecpHcpCode/text()"/></HcpCode>
					<HcpName><xsl:value-of select="//RecpHcpDescription/text()"/></HcpName>
					<OrgCode IdType="PRA"><xsl:value-of select="//RecpPracticeCode/text()"/></OrgCode>
					<OrgName><xsl:value-of select="//RecpPracticeName/text()"/></OrgName>
					<LogicalAddress>urn:nhs-uk:addressing:ods:PCT1234</LogicalAddress>
				</Party>
				<!--  Sender  -->
				<Party AgentId="2">
					<HcpCode IdType="Internal"><xsl:value-of select="//SendHCPCode/text()"/></HcpCode>
					<HcpName><xsl:value-of select="//SendHCPDesc/text()"/></HcpName>
					<BossCode IdType="Specialist">C3524271</BossCode>
					<BossName>Siddiqi, Mashood</BossName>
					<DepartmentCode IdType="Internal">3010</DepartmentCode>
					<DepartmentName><xsl:value-of select="//SendDepartment/text()"/></DepartmentName>
					<OrgCode IdType="Provider"><xsl:value-of select="//OrgCode/text()"/></OrgCode>
					<OrgName><xsl:value-of select="//OrgName/text()"/></OrgName>
				</Party>
			</Parties>
			<!--  Read Codes  -->
			<CodedData>
				<ClinicalCode Type="Read" Schema="2">
					<TermID>1</TermID>
					<Term30>Serial peak expiratory flow rate</Term30>
					<Term60/>
					<CodeName>339g.</CodeName>
					<Value1>100</Value1>
					<Unit1/>
				</ClinicalCode>
			</CodedData>
			<!--  Additional Reporting Information  -->
			<ReportingInformation>
				<!--  New or Followup -->
				<ReportingReason>New</ReportingReason>
				<!--  Reporting reference eg PO number -->
				<ReportingReferenceNumber>7268874342</ReportingReferenceNumber>
				<!--  Action requested by receiver? -->
				<ActionRequested>N</ActionRequested>
				<!--  Patient medication changed? -->
				<MedicationChanged>N</MedicationChanged>
			</ReportingInformation>
		<!--  Element added for EDT -->
			<ClinicalReport>
			<!--
			 This is the unique document id in EDT Server that the recipient needs to record 
			-->
			<ReportID><xsl:value-of select="//DocumentID/text()"/></ReportID>
			<!--  Document Description  -->
			<ReportType><xsl:value-of select="//ReportType/text()"/></ReportType>
			<!--
			 Short description to categorise incoming letter type 
			-->
			<ReportCode>GPLETTER</ReportCode>
			<!--  Use EDT_GetSourceTypes method to get an ID  -->
			<ReportSourceType>1</ReportSourceType>
			<!--  Person who typed the letter  -->
			<ReportContributor/>
			<!--  Clinical Event Date  -->
			<EventDate><xsl:value-of select="//EventDate/text()"/></EventDate>
			<!--  Clinical End Date (if any)  -->
			<EventDateEnd><xsl:value-of select="//EventDateEnd/text()"/></EventDateEnd>
			<!--  Document Creation Date  -->
			<DocCreationDate><xsl:value-of select="//DocCreationDate/text()"/></DocCreationDate>
			<!--  Encoded B64 Image of Document  -->
			<TextItem RcStatus="Current">
				<Cuid IdScope="Message"/>
				<TextMarkupIndicator>-//IETF//DTD HTML//EN</TextMarkupIndicator>
				<TextBlock></TextBlock>
				</TextItem>
			</ClinicalReport>
		</ReportMsg>

	</xsl:template>
	
	
	<!-- 2nd method -->
	<xsl:template match="//PID.6.5/text()">MR</xsl:template>

	
</xsl:stylesheet>