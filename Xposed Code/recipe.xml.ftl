<?xml version="1.0"?>
<recipe>
<#if SocketProxy == true>
    <instantiate from="root/src/app_package/SocketProxy.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/SocketProxy.java" />
</#if>
<#if ClassesEnum == true>
    <instantiate from="root/src/app_package/ClassesEnum.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/ClassesEnum.java" />
</#if>

</recipe>
