<?xml version="1.0"?>
<recipe>

    <merge from="root/AndroidManifest.xml.ftl"
             to="${escapeXmlAttribute(manifestOut)}/AndroidManifest.xml" />
    <mkdir at="${escapeXmlAttribute(projectOut)}/libs" />
	<copy from="root/lib"
		to="${escapeXmlAttribute(projectOut)}/lib" />
    <merge from="root/build.gradle.ftl"
             to="${escapeXmlAttribute(projectOut)}/build.gradle" />
	
	<mkdir at="${escapeXmlAttribute(manifestOut)}/assets/" />
	<instantiate from="root/xposed_init.ftl"
			   to="${escapeXmlAttribute(manifestOut)}/assets/xposed_init" />
				   
    <instantiate from="root/src/app_package/XposedModule.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}.java" />
    <open file="${escapeXmlAttribute(srcOut)}/${className}.java" />
</recipe>
