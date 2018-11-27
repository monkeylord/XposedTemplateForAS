<?xml version="1.0"?>
<recipe>
    <instantiate from="root/src/app_package/XposedHook.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
    <open file="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
<#if hookType == "net">
    <instantiate from="root/src/app_package/netUtil.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/netUtil.java" />
	<merge from="root/build.gradle.ftl"
                   to="${escapeXmlAttribute(projectOut)}/build.gradle" />
</#if>

</recipe>
