package ${packageName};

import android.content.pm.ApplicationInfo;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/*
	某些Android 4版本，需要修改依赖库的配置才能兼容，否则会报pre-verifed错误。
	原因：Framework也提供了XposedBridgeApi，和编译进插件的内容重复。所以要把XposedBridgeApi从编译改为引用。
	修改：Build->Edit Libraries and Dependencies  将XposedBridgeApi的scope从compile改为provided

*/

public class ${className} implements IXposedHookLoadPackage {

	<#if specific>
	String targetApp="${targetApp}";
	</#if>
    String packageName;
    Boolean isFirstApplication;
    ClassLoader classLoader;
    String processName;
    ApplicationInfo appInfo;
	
	@Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam loadPackageParam) throws Throwable {
		<#if specific>
		if(!loadPackageParam.packageName.equals(targetApp))return;
		</#if>
		gatherInfo(loadPackageParam);
		//Write your code here.
		
		
		
    }
    private void gatherInfo(XC_LoadPackage.LoadPackageParam loadPackageParam){
        packageName=loadPackageParam.packageName;
        isFirstApplication=loadPackageParam.isFirstApplication;
        classLoader=loadPackageParam.classLoader;
        processName=loadPackageParam.processName;
        appInfo=loadPackageParam.appInfo;
    }
}
