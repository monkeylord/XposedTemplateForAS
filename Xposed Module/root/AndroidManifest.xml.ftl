<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="${packageName}">
    <application>
		<meta-data
            android:name="xposedmodule"
            android:value="true"
            />
        <meta-data
            android:name="xposedminversion"
            android:value="40"
            />
        <meta-data
            android:name="xposeddescription"
            android:value="${moduleDescription}"
            />
<#if select == "selector">
        <activity 
			android:name=".${className}Selector"
			android:label="${moduleName}\n AppSelector">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
</#if>
    </application>

</manifest>
