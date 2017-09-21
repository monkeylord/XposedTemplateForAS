<?xml version="1.0"?>
<recipe>
	<mkdir at="${escapeXmlAttribute(srcOut)}/extend/" />
    <instantiate from="root/src/app_package/Timing.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/extend/Timing.java" />	
</recipe>
