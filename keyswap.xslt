<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"

  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/"
  xmlns:lightroom="http://ns.adobe.com/lightroom/1.0/"
  xmlns:Iptc4xmpCore="http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/"
  version="1.0">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" encoding="utf-8"/>
<xsl:strip-space elements="*"/>

 <xsl:template match="node()|@*" name="identity">
  <xsl:copy>
   <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
 </xsl:template>

 <!-- copy into: 
     /rdf:RDF/rdf:Description/dc:description/rdf:Alt 
     things we find in
      /rdf:RDF/rdf:Description/lightroom:hierarchicalSubject/rdf:Bag/rdf:li
      after passing it through a simple JS function that will take only the last heirarchial keyword (Assuming last portion after last | char)
-->

<msxsl:script implements-prefix='user' language='JavaScript'>
    <![CDATA[
      function lastHierarchicalKeyword(str){
        return (str.substr(str.lastIndexOf('|')+1));
      }
    ]]>
</msxsl:script>

<!-- Red in p1 commandline parameter -->
<xsl:param name="p1" select="p1"/>

 <xsl:template match="rdf:Description/*[1][not(../dc:description)]">
    <dc:description> 
      <xsl:call-template name="add-strings"/>
    </dc:description>
  <xsl:call-template name="identity"/>  
</xsl:template> 

<!-- Template to add the photoshop namespace declaration to rdf:Description -->
<xsl:template match="rdf:Description">
  <rdf:Description xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/">
    <xsl:apply-templates select="@*|node()"/>
  </rdf:Description>
</xsl:template>


<!-- Template to insert photoshop:TransmissionReference -->
<xsl:template match="dc:creator">
  <xsl:text disable-output-escaping="yes">&#10;&lt;photoshop:TransmissionReference&gt;</xsl:text>
  <xsl:value-of select="$p1" />
  <xsl:text disable-output-escaping="yes">&lt;/photoshop:TransmissionReference&gt;&#10;</xsl:text>
  <xsl:call-template name="identity"/>
</xsl:template>

<xsl:template match="dc:description">
  <xsl:copy>
    <xsl:call-template name="add-strings"/>
  </xsl:copy>    
</xsl:template>  

<xsl:template name="add-strings">
<rdf:Alt>
  <rdf:li>
    <xsl:for-each select="//lightroom:hierarchicalSubject/rdf:Bag/rdf:li">
      <xsl:value-of select="user:lastHierarchicalKeyword(string(node()))" />
      <xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
  </rdf:li>
</rdf:Alt>
</xsl:template>

</xsl:stylesheet>