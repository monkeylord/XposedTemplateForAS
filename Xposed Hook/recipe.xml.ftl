<?xml version="1.0"?>
<recipe>
<#if hookType == "net">
    <instantiate from="root/src/app_package/netUtil.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/netUtil.java" />
</#if>
    <instantiate from="root/src/app_package/XposedHook.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
    <open file="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
</recipe>
