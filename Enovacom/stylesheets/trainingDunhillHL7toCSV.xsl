<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xalan xsi" version="1.0"
    xmlns:xalan="http://xml.apache.org/xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--This file has been generated by Enovacom Suite V2 Mapper v1.2.6-->
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:template match="/root">
        <xsl:variable name="rootNode" select="."/>
        <xsl:element name="root">
            <xsl:element name="row">
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var1_PID" select="."/>
                    <xsl:for-each select="PID.3.4">
                        <xsl:variable name="var2_PID.3.4" select="."/>
                        <xsl:for-each select="$var1_PID/PID.5.5">
                            <xsl:variable name="var3_PID.5.5" select="."/>
                            <xsl:variable name="var4_constante_value">
                                <xsl:text><![CDATA[ ]]></xsl:text>
                            </xsl:variable>
                            <xsl:element name="firstname">
                                <xsl:value-of select="concat($var2_PID.3.4, string($var4_constante_value), $var3_PID.5.5)"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var5_PID" select="."/>
                    <xsl:for-each select="PID.3.5">
                        <xsl:variable name="var6_PID.3.5" select="."/>
                        <xsl:element name="lastname">
                            <xsl:value-of select="$var6_PID.3.5"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="$rootNode/PID">
                    <xsl:variable name="var7_PID" select="."/>
                    <xsl:for-each select="PID.3.1">
                        <xsl:variable name="var8_PID.3.1" select="."/>
                        <xsl:element name="id">
                            <xsl:value-of select="$var8_PID.3.1"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>