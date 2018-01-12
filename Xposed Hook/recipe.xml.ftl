<?xml version="1.0"?>
<recipe>
    <instantiate from="root/src/app_package/XposedHook.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
    <open file="${escapeXmlAttribute(srcOut)}/${hookName}.java" />
<#if hookType == "net">
    <instantiate from="root/src/app_package/netUtil.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/netUtil.java" />
    <copy from="root/src/app_package/local-http-server.py"
                   to="${escapeXmlAttribute(projectOut)}/../local-http-server.py" />
	<open file="${escapeXmlAttribute(projectOut)}/../local-http-server.py" />   
</#if>

</recipe>
