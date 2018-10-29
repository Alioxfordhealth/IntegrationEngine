<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xalan xsi" version="1.0"
    xmlns:xalan="http://xml.apache.org/xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Ce fichier a été généré par Antares Mapper v1.2.3-->
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:template name="table26294">
        <xsl:param name="input"/>
        <xsl:variable name="tab_val0">
            <xsl:text><![CDATA[0]]></xsl:text>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$input=$tab_val0"><![CDATA[false]]></xsl:when>
            <xsl:otherwise><![CDATA[true]]></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="/infosBDD">
        <xsl:variable name="rootNode" select="."/>
        <xsl:element name="eai">
		<xsl:element name="moteurs">
                <xsl:element name="moteur">
		</xsl:element>
                    
                </xsl:element>

            <!--<xsl:element name="moteurs">
                <xsl:element name="moteur">
                    <xsl:element name="actif">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="addrmail">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="smtpserver">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="portsmtp">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="authentsmtp">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="loginsmtp">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="pwdsmtp">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="nivlog">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="replog">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="lignesparpage">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="dureerecherche">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="tempsrecherche">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="optionaffichage">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:element name="purgelog">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </xsl:element>
                    <xsl:text><![CDATA[]]></xsl:text>
                </xsl:element>
                <xsl:text><![CDATA[]]></xsl:text>
            </xsl:element>-->
            <xsl:element name="formats">
                <xsl:for-each select="$rootNode/formats">
                    <xsl:variable name="var1_formats" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var2_row" select="."/>
                        <xsl:element name="format">
                            <xsl:for-each select="$var2_row/PK_FORMAT">
                                <xsl:variable name="var3_PK_FORMAT" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var3_PK_FORMAT"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var2_row/NOM">
                                <xsl:variable name="var4_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var4_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var2_row/TYPE">
                                <xsl:variable name="var5_TYPE" select="."/>
                                <xsl:element name="type">
                                    <xsl:value-of select="$var5_TYPE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="propsFormat">
                                <xsl:for-each select="$var2_row/row">
                                    <xsl:variable name="var6_row" select="."/>
                                    <xsl:element name="propFormat">
                                    <xsl:for-each select="$var6_row/NOM">
                                    <xsl:variable
                                    name="var7_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var7_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var6_row/VALEUR">
                                    <xsl:variable
                                    name="var8_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var8_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="typesDocument">
                <xsl:for-each select="$rootNode/typeDocs">
                    <xsl:variable name="var9_typeDocs" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var10_row" select="."/>
                        <xsl:element name="typeDocument">
                            <xsl:for-each select="$var10_row/PK_TYPEDOCUMENT">
                                <xsl:variable
                                    name="var11_PK_TYPEDOCUMENT" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var11_PK_TYPEDOCUMENT"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var10_row/NOM">
                                <xsl:variable name="var12_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var12_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="refFormat">
                                <xsl:for-each select="$var10_row/PK_FORMAT">
                                    <xsl:variable name="var13_PK_FORMAT" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var13_PK_FORMAT"/>
                                    </xsl:attribute>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:element name="refSchema">
                                <xsl:for-each select="$var10_row/SCHEMA">
                                    <xsl:variable name="var14_SCHEMA" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var14_SCHEMA"/>
                                    </xsl:attribute>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:for-each select="$var10_row">
                                <xsl:variable name="var16_row" select="."/>
                                <xsl:for-each select="ZIPPABLE">
                                    <xsl:variable name="var17_ZIPPABLE" select="."/>
                                    <xsl:variable name="var18_constante_value">
                                    <xsl:text><![CDATA[0]]></xsl:text>
                                    </xsl:variable>
                                    <xsl:variable name="var15_boolean">
                                    <xsl:value-of select="($var17_ZIPPABLE) = (string($var18_constante_value))"/>
                                    </xsl:variable>
                                    <xsl:variable name="var19_condition">
                                    <xsl:choose>
                                    <xsl:when test="string($var15_boolean)='true'">
                                    <xsl:text><![CDATA[false]]></xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    <xsl:text><![CDATA[true]]></xsl:text>
                                    </xsl:otherwise>
                                    </xsl:choose>
                                    </xsl:variable>
                                    <xsl:element name="zippable">
                                    <xsl:value-of select="$var19_condition"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="proprietes">
                <xsl:for-each select="$rootNode/proprietes">
                    <xsl:variable name="var20_proprietes" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var21_row" select="."/>
                        <xsl:element name="propriete">
                            <xsl:for-each select="$var21_row/PK_PROPRIETE">
                                <xsl:variable name="var22_PK_PROPRIETE" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var22_PK_PROPRIETE"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var21_row/NOM">
                                <xsl:variable name="var23_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var23_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var21_row/TYPE">
                                <xsl:variable name="var24_TYPE" select="."/>
                                <xsl:element name="type">
                                    <xsl:value-of select="$var24_TYPE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var21_row/SOUSTYPE">
                                <xsl:variable name="var25_SOUSTYPE" select="."/>
                                <xsl:element name="sousType">
                                    <xsl:value-of select="$var25_SOUSTYPE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var21_row">
                                <xsl:variable name="var26_row" select="."/>
                                <xsl:for-each select="OBLIGATOIRE">
                                    <xsl:variable
                                    name="var27_OBLIGATOIRE" select="."/>
                                    <xsl:variable name="var28_table26294">
                                    <xsl:call-template name="table26294">
                                    <xsl:with-param name="input" select="$var27_OBLIGATOIRE"/>
                                    </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:element name="obligatoire">
                                    <xsl:value-of select="$var28_table26294"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="$var21_row/DESCRIPTION">
                                <xsl:variable name="var29_DESCRIPTION" select="."/>
                                <xsl:element name="description">
                                    <xsl:value-of select="$var29_DESCRIPTION"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="modelesApplication">
                <xsl:for-each select="$rootNode/modeles">
                    <xsl:variable name="var30_modeles" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var31_row" select="."/>
                        <xsl:element name="application">
                            <xsl:for-each select="$var31_row/PK_APPLICATION">
                                <xsl:variable
                                    name="var32_PK_APPLICATION" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var32_PK_APPLICATION"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var31_row/NOM">
                                <xsl:variable name="var33_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var33_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var31_row/DESCRIPTION">
                                <xsl:variable name="var34_DESCRIPTION" select="."/>
                                <xsl:element name="desc">
                                    <xsl:value-of select="$var34_DESCRIPTION"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="proprietesApplication">
                                <xsl:for-each select="$var31_row/row">
                                    <xsl:variable name="var35_row" select="."/>
                                    <xsl:element name="proprieteApplication">
                                    <xsl:element name="refPropriete">
                                    <xsl:for-each select="$var35_row/PK_PROPRIETE">
                                    <xsl:variable
                                    name="var36_PK_PROPRIETE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var36_PK_PROPRIETE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    </xsl:element>
                                    <xsl:for-each select="$var35_row/VALEUR">
                                    <xsl:variable
                                    name="var37_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var37_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="applications">
                <xsl:for-each select="$rootNode/applis">
                    <xsl:variable name="var38_applis" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var39_row" select="."/>
                        <xsl:element name="application">
                            <xsl:for-each select="$var39_row/PK_APPLICATION">
                                <xsl:variable
                                    name="var40_PK_APPLICATION" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var40_PK_APPLICATION"/>
                                </xsl:attribute>
                                <xsl:attribute name="show">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var39_row/NOM">
                                <xsl:variable name="var41_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var41_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var39_row">
                                <xsl:variable name="var43_row" select="."/>
                                <xsl:for-each select="FK_APPLICATION_TEMPLATE">
                                    <xsl:variable
                                    name="var44_FK_APPLICATION_TEMPLATE" select="."/>
                                    <xsl:variable name="var45_constante_value">
                                    <xsl:text><![CDATA[0]]></xsl:text>
                                    </xsl:variable>
                                    <xsl:variable name="var42_boolean">
                                    <xsl:value-of select="(number(string-length($var44_FK_APPLICATION_TEMPLATE))) >(number(string($var45_constante_value)))"/>
                                    </xsl:variable>
                                    <xsl:variable name="var46_condition">
                                    <xsl:choose>
                                    <xsl:when test="string($var42_boolean)='true'">
                                    <xsl:value-of select="$var44_FK_APPLICATION_TEMPLATE"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    <xsl:text><![CDATA[-1]]></xsl:text>
                                    </xsl:otherwise>
                                    </xsl:choose>
                                    </xsl:variable>
                                    <xsl:element name="fkApplicationTemplate">
                                    <xsl:value-of select="$var46_condition"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="$var39_row/DESCRIPTION">
                                <xsl:variable name="var47_DESCRIPTION" select="."/>
                                <xsl:element name="desc">
                                    <xsl:value-of select="$var47_DESCRIPTION"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="proprietesApplication">
                                <xsl:for-each select="$var39_row/row">
                                    <xsl:variable name="var48_row" select="."/>
                                    <xsl:element name="proprieteApplication">
                                    <xsl:element name="refPropriete">
                                    <xsl:for-each select="$var48_row/PK_PROPRIETE">
                                    <xsl:variable
                                    name="var49_PK_PROPRIETE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var49_PK_PROPRIETE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    </xsl:element>
                                    <xsl:for-each select="$var48_row/VALEUR">
                                    <xsl:variable
                                    name="var50_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var50_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="utilisateurs">
                <xsl:for-each select="$rootNode/utilisateurs">
                    <xsl:variable name="var209_utilisateurs" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var210_row" select="."/>
                        <xsl:element name="utilisateur">
                            <xsl:for-each select="$var210_row/PK_UTILISATEUR">
                                <xsl:variable
                                    name="var211_PK_UTILISATEUR" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var211_PK_UTILISATEUR"/>
                                </xsl:attribute>
                                <xsl:attribute name="show">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var210_row/LOGIN">
                                <xsl:variable name="var212_LOGIN" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var212_LOGIN"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/NOM">
                                <xsl:variable name="var213_NOM" select="."/>
                                <xsl:element name="longnom">
                                    <xsl:value-of select="$var213_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/PASSHASH">
                                <xsl:variable name="var214_PASSHASH" select="."/>
                                <xsl:element name="passhash">
                                    <xsl:value-of select="$var214_PASSHASH"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/EMAILADDR">
                                <xsl:variable name="var215_EMAILADDR" select="."/>
                                <xsl:element name="emailaddr">
                                    <xsl:value-of select="$var215_EMAILADDR"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/ETAT">
                                <xsl:variable name="var216_ETAT" select="."/>
                                <xsl:element name="etat">
                                    <xsl:value-of select="$var216_ETAT"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/DESTALERTE">
                                <xsl:variable name="var217_DESTALERTE" select="."/>
                                <xsl:element name="destalerte">
                                    <xsl:value-of select="$var217_DESTALERTE"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/DATECREATION">
                                <xsl:variable name="var218_DATECREATION" select="."/>
                                <xsl:element name="datecreation">
                                    <xsl:value-of select="$var218_DATECREATION"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var210_row/LASTUPDATE">
                                <xsl:variable name="var219_LASTUPDATE" select="."/>
                                <xsl:element name="lastupdate">
                                    <xsl:value-of select="$var219_LASTUPDATE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="refsGroupe">
                                <xsl:for-each select="$var210_row/rowGroupe">
                                    <xsl:variable name="var220_row" select="."/>
                                    <xsl:element name="refGroupe">
										<xsl:for-each select="$var220_row/PK_GROUPE">
											<xsl:variable name="var221_PK_GROUPE" select="."/>
												<xsl:attribute name="id">
													<xsl:value-of select="$var221_PK_GROUPE"/>
												</xsl:attribute>
											</xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:element name="onglets">
                                <xsl:for-each select="$var210_row/rowOnglet">
                                    <xsl:variable name="var226_row" select="."/>
                                    <xsl:element name="onglet">
										<xsl:for-each select="$var226_row/DESCRIPTION">
											<xsl:variable name="var227_DESCRIPTION" select="substring(.,6)"/>
											<xsl:attribute name="nom">
												<xsl:value-of select="$var227_DESCRIPTION"/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:element name="suivis">
											<xsl:for-each select="$var226_row/row">
												<xsl:variable name="var228_row" select="."/>
												<xsl:element name="suivi">
													<xsl:for-each select="$var228_row/NOM">
														<xsl:variable name="var229_NOM" select="."/>
														<xsl:attribute name="nom">
															<xsl:value-of select="$var229_NOM"/>
														</xsl:attribute>
													</xsl:for-each>
												</xsl:element>
											</xsl:for-each>
										</xsl:element>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:element name="typesNotifApplis">
                                <xsl:for-each select="$var210_row/rowNotif">
                                    <xsl:variable name="var224_row" select="."/>
                                    <xsl:element name="typeNotifApplis">
										<xsl:for-each select="$var224_row/PK_TYPENOTIFICATION">
											<xsl:variable name="var225_PK_TYPENOTIFICATION" select="."/>
											<xsl:attribute name="refId">
												<xsl:value-of select="$var225_PK_TYPENOTIFICATION"/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:for-each select="$var224_row/row">
											<xsl:variable name="var230_row" select="."/>
											<xsl:element name="refAppli">
												<xsl:for-each select="$var230_row/PK_APPLICATION">
													<xsl:variable name="var231_PK_APPLICATION" select="."/>
													<xsl:attribute name="id">
														<xsl:value-of select="$var231_PK_APPLICATION"/>
													</xsl:attribute>
												</xsl:for-each>
											</xsl:element>
										</xsl:for-each>
			                            <xsl:if test="count($var224_row/row)=0">
											<xsl:element name="refAppli">
												<xsl:attribute name="id">
													<xsl:value-of select="0"/>
												</xsl:attribute>
											</xsl:element>
											<xsl:element name="refAppli">
												<xsl:attribute name="id">
													<xsl:value-of select="-1"/>
												</xsl:attribute>
											</xsl:element>
											
										</xsl:if>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="groupes">
                <xsl:for-each select="$rootNode/groupes">
                    <xsl:variable name="var232_utilisateurs" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var233_row" select="."/>
                        <xsl:element name="groupe">
                            <xsl:for-each select="$var233_row/PK_GROUPE">
                                <xsl:variable
                                    name="var234_PK_GROUPE" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var234_PK_GROUPE"/>
                                </xsl:attribute>
                                <xsl:attribute name="show">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var233_row/NOM">
                                <xsl:variable name="var235_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var235_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var233_row/DESCRIPTION">
                                <xsl:variable name="var236_DESCRIPTION" select="."/>
                                <xsl:element name="description">
                                    <xsl:value-of select="$var236_DESCRIPTION"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var233_row/DATECREATION">
                                <xsl:variable name="var237_DATECREATION" select="."/>
                                <xsl:element name="datecreation">
                                    <xsl:value-of select="$var237_DATECREATION"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var233_row/LASTUPDATE">
                                <xsl:variable name="var238_LASTUPDATE" select="."/>
                                <xsl:element name="lastupdate">
                                    <xsl:value-of select="$var238_LASTUPDATE"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var233_row/SEEMESSAGE">
                                <xsl:variable name="var239_SEEMESSAGE" select="."/>
                                <xsl:element name="refsRessource">
                                    <xsl:value-of select="$var239_SEEMESSAGE"/>
                                </xsl:element>
                            </xsl:for-each>
							<xsl:for-each select="$var233_row/LIFECYCLE_COMPONENT">
                                <xsl:variable name="var240_LIFECYCLE_COMPONENT" select="."/>
                                <xsl:element name="typesNotifApplis">
                                    <xsl:value-of select="$var240_LIFECYCLE_COMPONENT"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="typesNotification">
                <xsl:for-each select="$rootNode/signalements">
                    <xsl:variable name="var51_signalements" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var52_row" select="."/>
                        <xsl:element name="typeNotification">
                            <xsl:for-each select="$var52_row/PK_TYPENOTIFICATION">
                                <xsl:variable
                                    name="var53_PK_TYPENOTIFICATION" select="."/>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$var53_PK_TYPENOTIFICATION"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/NOM">
                                <xsl:variable name="var54_NOM" select="."/>
                                <xsl:element name="nom">
                                    <xsl:value-of select="$var54_NOM"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/DESCRIPTION">
                                <xsl:variable name="var55_DESCRIPTION" select="."/>
                                <xsl:element name="desc">
                                    <xsl:value-of select="$var55_DESCRIPTION"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/CATEGORIE">
                                <xsl:variable name="var56_CATEGORIE" select="."/>
                                <xsl:element name="categorie">
                                    <xsl:value-of select="$var56_CATEGORIE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/TYPE">
                                <xsl:variable name="var57_TYPE" select="."/>
                                <xsl:element name="type">
                                    <xsl:value-of select="$var57_TYPE"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/TYPE_APPLI_DEST">
                                <xsl:variable
                                    name="var58_TYPE_APPLI_DEST" select="."/>
                                <xsl:element name="typeAppliDest">
                                    <xsl:value-of select="$var58_TYPE_APPLI_DEST"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$var52_row/NBOCCTOSEND">
                                <xsl:variable name="var59_NBOCCTOSEND" select="."/>
                                <xsl:element name="nbOccToSend">
                                    <xsl:value-of select="$var59_NBOCCTOSEND"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:element name="refModele">
                                <xsl:for-each select="$var52_row">
                                    <xsl:variable name="var61_row" select="."/>
                                    <xsl:for-each select="PK_APPLICATION">
                                    <xsl:variable
                                    name="var62_PK_APPLICATION" select="."/>
                                    <xsl:variable name="var63_constante_value">
                                    <xsl:text><![CDATA[0]]></xsl:text>
                                    </xsl:variable>
                                    <xsl:variable name="var60_boolean">
                                    <xsl:value-of select="(number(string-length($var62_PK_APPLICATION))) >(number(string($var63_constante_value)))"/>
                                    </xsl:variable>
                                    <xsl:variable name="var64_condition">
                                    <xsl:choose>
                                    <xsl:when test="string($var60_boolean)='true'">
                                    <xsl:value-of select="$var62_PK_APPLICATION"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    <xsl:text><![CDATA[-1]]></xsl:text>
                                    </xsl:otherwise>
                                    </xsl:choose>
                                    </xsl:variable>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var64_condition"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[WORKFLOW]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var66_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var68_row" select="."/>
                        <xsl:variable name="var67_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var69_TYPE" select="."/>
                            <xsl:variable name="var70_constante_value">
                                <xsl:text><![CDATA[WORKFLOW]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var65_ExistsResult">
                                <xsl:variable
                                    name="var71_boolean_result" select="($var69_TYPE) = (string($var70_constante_value))"/>
                                <xsl:if test="string($var71_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var72_exists" select="string-length($var65_ExistsResult)>0"/>
                            <xsl:if test="string($var72_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var68_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var73_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var73_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var68_row/NOM">
                                    <xsl:variable name="var74_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var74_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var68_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var75_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var75_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var68_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var76_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var76_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var68_row/ACTIF">
                                    <xsl:variable name="var77_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var77_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var68_row/row">
                                    <xsl:variable
                                    name="var78_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var78_row/NOM">
                                    <xsl:variable
                                    name="var79_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var79_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var78_row/VALEUR">
                                    <xsl:variable
                                    name="var80_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var80_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[ROUTEUR]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var82_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var84_row" select="."/>
                        <xsl:variable name="var83_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var85_TYPE" select="."/>
                            <xsl:variable name="var86_constante_value">
                                <xsl:text><![CDATA[ROUTEUR]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var81_ExistsResult">
                                <xsl:variable
                                    name="var87_boolean_result" select="($var85_TYPE) = (string($var86_constante_value))"/>
                                <xsl:if test="string($var87_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var88_exists" select="string-length($var81_ExistsResult)>0"/>
                            <xsl:if test="string($var88_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var84_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var89_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var89_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var84_row/NOM">
                                    <xsl:variable name="var90_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var90_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var84_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var91_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var91_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var84_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var92_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var92_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var84_row/ACTIF">
                                    <xsl:variable name="var93_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var93_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var84_row/row">
                                    <xsl:variable
                                    name="var94_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var94_row/NOM">
                                    <xsl:variable
                                    name="var95_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var95_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var94_row/VALEUR">
                                    <xsl:variable
                                    name="var96_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var96_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[MODELE]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var98_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var100_row" select="."/>
                        <xsl:variable name="var99_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var101_TYPE" select="."/>
                            <xsl:variable name="var102_constante_value">
                                <xsl:text><![CDATA[MODELE]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var97_ExistsResult">
                                <xsl:variable
                                    name="var103_boolean_result" select="($var101_TYPE) = (string($var102_constante_value))"/>
                                <xsl:if test="string($var103_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var104_exists" select="string-length($var97_ExistsResult)>0"/>
                            <xsl:if test="string($var104_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var100_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var105_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var105_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var100_row/NOM">
                                    <xsl:variable name="var106_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var106_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var100_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var107_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var107_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var100_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var108_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var108_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var100_row/ACTIF">
                                    <xsl:variable
                                    name="var109_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var109_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var100_row/row">
                                    <xsl:variable
                                    name="var110_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var110_row/NOM">
                                    <xsl:variable
                                    name="var111_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var111_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var110_row/VALEUR">
                                    <xsl:variable
                                    name="var112_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var112_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[TABLE_CORRESPONDANCE]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var114_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var116_row" select="."/>
                        <xsl:variable name="var115_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var117_TYPE" select="."/>
                            <xsl:variable name="var118_constante_value">
                                <xsl:text><![CDATA[TABLE_CORRESPONDANCE]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var113_ExistsResult">
                                <xsl:variable
                                    name="var119_boolean_result" select="($var117_TYPE) = (string($var118_constante_value))"/>
                                <xsl:if test="string($var119_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var120_exists" select="string-length($var113_ExistsResult)>0"/>
                            <xsl:if test="string($var120_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var116_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var121_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var121_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var116_row/NOM">
                                    <xsl:variable name="var122_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var122_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var116_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var123_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var123_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var116_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var124_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var124_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var116_row/ACTIF">
                                    <xsl:variable
                                    name="var125_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var125_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var116_row/row">
                                    <xsl:variable
                                    name="var126_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var126_row/NOM">
                                    <xsl:variable
                                    name="var127_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var127_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var126_row/VALEUR">
                                    <xsl:variable
                                    name="var128_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var128_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[REQUETE_SQL]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var130_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var132_row" select="."/>
                        <xsl:variable name="var131_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var133_TYPE" select="."/>
                            <xsl:variable name="var134_constante_value">
                                <xsl:text><![CDATA[REQUETE_SQL]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var129_ExistsResult">
                                <xsl:variable
                                    name="var135_boolean_result" select="($var133_TYPE) = (string($var134_constante_value))"/>
                                <xsl:if test="string($var135_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var136_exists" select="string-length($var129_ExistsResult)>0"/>
                            <xsl:if test="string($var136_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var132_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var137_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var137_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var132_row/NOM">
                                    <xsl:variable name="var138_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var138_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var132_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var139_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var139_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var132_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var140_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var140_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var132_row/ACTIF">
                                    <xsl:variable
                                    name="var141_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var141_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var132_row/row">
                                    <xsl:variable
                                    name="var142_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var142_row/NOM">
                                    <xsl:variable
                                    name="var143_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var143_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var142_row/VALEUR">
                                    <xsl:variable
                                    name="var144_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var144_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[JDBC_DATA_SOURCE]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var146_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var148_row" select="."/>
                        <xsl:variable name="var147_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var149_TYPE" select="."/>
                            <xsl:variable name="var150_constante_value">
                                <xsl:text><![CDATA[JDBC_DATA_SOURCE]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var145_ExistsResult">
                                <xsl:variable
                                    name="var151_boolean_result" select="($var149_TYPE) = (string($var150_constante_value))"/>
                                <xsl:if test="string($var151_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var152_exists" select="string-length($var145_ExistsResult)>0"/>
                            <xsl:if test="string($var152_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var148_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var153_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var153_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var148_row/NOM">
                                    <xsl:variable name="var154_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var154_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var148_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var155_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var155_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var148_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var156_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var156_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var148_row/ACTIF">
                                    <xsl:variable
                                    name="var157_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var157_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var148_row/row">
                                    <xsl:variable
                                    name="var158_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var158_row/NOM">
                                    <xsl:variable
                                    name="var159_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var159_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var158_row/VALEUR">
                                    <xsl:variable
                                    name="var160_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var160_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[SERVICE_IN]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var162_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var164_row" select="."/>
                        <xsl:variable name="var163_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var165_TYPE" select="."/>
                            <xsl:variable name="var166_constante_value">
                                <xsl:text><![CDATA[SERVICE_IN]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var161_ExistsResult">
                                <xsl:variable
                                    name="var167_boolean_result" select="($var165_TYPE) = (string($var166_constante_value))"/>
                                <xsl:if test="string($var167_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var168_exists" select="string-length($var161_ExistsResult)>0"/>
                            <xsl:if test="string($var168_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var164_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var169_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var169_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var164_row/NOM">
                                    <xsl:variable name="var170_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var170_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var164_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var171_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var171_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var164_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var172_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var172_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var164_row/ACTIF">
                                    <xsl:variable
                                    name="var173_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var173_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var164_row/row">
                                    <xsl:variable
                                    name="var174_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var174_row/NOM">
                                    <xsl:variable
                                    name="var175_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var175_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var174_row/VALEUR">
                                    <xsl:variable
                                    name="var176_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var176_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[SERVICE_OUT]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var178_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var180_row" select="."/>
                        <xsl:variable name="var179_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var181_TYPE" select="."/>
                            <xsl:variable name="var182_constante_value">
                                <xsl:text><![CDATA[SERVICE_OUT]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var177_ExistsResult">
                                <xsl:variable
                                    name="var183_boolean_result" select="($var181_TYPE) = (string($var182_constante_value))"/>
                                <xsl:if test="string($var183_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var184_exists" select="string-length($var177_ExistsResult)>0"/>
                            <xsl:if test="string($var184_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var180_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var185_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var185_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var180_row/NOM">
                                    <xsl:variable name="var186_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var186_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var180_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var187_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var187_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var180_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var188_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var188_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var180_row/ACTIF">
                                    <xsl:variable
                                    name="var189_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var189_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var180_row/row">
                                    <xsl:variable
                                    name="var190_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var190_row/NOM">
                                    <xsl:variable
                                    name="var191_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var191_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var190_row/VALEUR">
                                    <xsl:variable
                                    name="var192_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var192_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
			            <xsl:element name="ressources">
                <xsl:attribute name="type">
                    <xsl:text><![CDATA[MODULE_SUPERVISION]]></xsl:text>
                </xsl:attribute>
                <xsl:for-each select="$rootNode/ressources">
                    <xsl:variable name="var194_ressources" select="."/>
                    <xsl:for-each select="row">
                        <xsl:variable name="var196_row" select="."/>
                        <xsl:variable name="var195_row" select="."/>
                        <xsl:for-each select="TYPE">
                            <xsl:variable name="var197_TYPE" select="."/>
                            <xsl:variable name="var198_constante_value">
                                <xsl:text><![CDATA[MODULE_SUPERVISION]]></xsl:text>
                            </xsl:variable>
                            <xsl:variable name="var193_ExistsResult">
                                <xsl:variable
                                    name="var199_boolean_result" select="($var197_TYPE) = (string($var198_constante_value))"/>
                                <xsl:if test="string($var199_boolean_result)='true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="var200_exists" select="string-length($var193_ExistsResult)>0"/>
                            <xsl:if test="string($var200_exists)='true'">
                                <xsl:element name="ressource">
                                    <xsl:for-each select="$var196_row/PK_RESSOURCE">
                                    <xsl:variable
                                    name="var201_PK_RESSOURCE" select="."/>
                                    <xsl:attribute name="id">
                                    <xsl:value-of select="$var201_PK_RESSOURCE"/>
                                    </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var196_row/NOM">
                                    <xsl:variable name="var202_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var202_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var196_row/DESCRIPTION">
                                    <xsl:variable
                                    name="var203_DESCRIPTION" select="."/>
                                    <xsl:element name="description">
                                    <xsl:value-of select="$var203_DESCRIPTION"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var196_row/SOUSTYPE">
                                    <xsl:variable
                                    name="var204_SOUSTYPE" select="."/>
                                    <xsl:element name="soustype">
                                    <xsl:value-of select="$var204_SOUSTYPE"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var196_row/ACTIF">
                                    <xsl:variable name="var205_ACTIF" select="."/>
                                    <xsl:element name="actif">
                                    <xsl:value-of select="$var205_ACTIF"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="propsRessource">
                                    <xsl:for-each select="$var196_row/row">
                                    <xsl:variable
                                    name="var206_row" select="."/>
                                    <xsl:element name="propRessource">
                                    <xsl:for-each select="$var206_row/NOM">
                                    <xsl:variable
                                    name="var207_NOM" select="."/>
                                    <xsl:element name="nom">
                                    <xsl:value-of select="$var207_NOM"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="$var206_row/VALEUR">
                                    <xsl:variable
                                    name="var208_VALEUR" select="."/>
                                    <xsl:element name="valeur">
                                    <xsl:value-of select="$var208_VALEUR"/>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                    </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
