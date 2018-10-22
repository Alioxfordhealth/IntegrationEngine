<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xalan xsi" version="1.0"
    xmlns:xalan="http://xml.apache.org/xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--This file has been generated by Enovacom Suite V2 Mapper v1.2.6-->
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:variable name="var1_paramValue">
        <xsl:text><![CDATA[Rachel]]></xsl:text>
    </xsl:variable>
    <xsl:param name="Prefix" select="$var1_paramValue"/>
    <xsl:template match="/root">
        <xsl:variable name="rootNode" select="."/>
        <xsl:element name="root">
            <xsl:element name="row">
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var2_PID" select="."/>
                    <xsl:for-each select="PID.5.2">
                        <xsl:variable name="var3_PID.5.2" select="."/>
                        <xsl:element name="firstname">
                            <xsl:value-of select="concat($Prefix, $var3_PID.5.2)"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var4_PID" select="."/>
                    <xsl:for-each select="PID.5.1">
                        <xsl:variable name="var5_PID.5.1" select="."/>
                        <xsl:variable name="var6_constante_value">
                            <xsl:text><![CDATA[1]]></xsl:text>
                        </xsl:variable>
                        <xsl:variable name="var7_constante_value">
                            <xsl:text><![CDATA[4]]></xsl:text>
                        </xsl:variable>
                        <xsl:element name="lastname">
                            <xsl:value-of select="substring($var5_PID.5.1, string($var6_constante_value), string($var7_constante_value))"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var8_PID" select="."/>
                    <xsl:for-each select="PID.3.1">
                        <xsl:variable name="var9_PID.3.1" select="."/>
                        <xsl:element name="id">
                            <xsl:value-of select="$var9_PID.3.1"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>