<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet declaration -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Declare Output -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- Parameters -->
  <xsl:param name="TargetApp"/>
  <xsl:param name="Prefix"/>

  <!-- Declare Identity -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Replace MSH.5.1 and MSH.6.1 with $TargetApp -->
	<xsl:template match="//MSH.5.1"></xsl:template>
  <xsl:template match="//MSH.6.1">
    <MSH.5.1><xsl:value-of select="$TargetApp"/></MSH.5.1>
    <MSH.6.1><xsl:value-of select="$TargetApp"/></MSH.6.1>
  </xsl:template>

  <!-- Remove EVN Segment -->
  <xsl:template match="//EVN"></xsl:template>

  <!-- Add prefix to PID.3.1 -->
  <xsl:template match="//PID.3.1">
    <PID.3.1><xsl:value-of select="concat($Prefix, ./text())"/></PID.3.1>
  </xsl:template>

  <!-- Substring of PID.5.1 -->
  <xsl:template match="//PID.5.1">
    <PID.5.1><xsl:value-of select="substring(./text(),1,4)" /></PID.5.1>
  </xsl:template>

  <!-- Add MSH.13.1 -->
  <xsl:template match="//MSH.13.1"></xsl:template>
  <xsl:template match="//MSH.12.1">
    <MSH.12.1><xsl:value-of select="./text()" /></MSH.12.1>
    <MSH.13.1>NIK</MSH.13.1>
  </xsl:template>

</xsl:stylesheet>    