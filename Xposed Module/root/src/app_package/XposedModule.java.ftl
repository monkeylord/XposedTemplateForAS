package ${packageName};

import android.content.pm.ApplicationInfo;
import android.os.Build;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.IXposedHookZygoteInit;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;
<#if select == "selector">
import de.robv.android.xposed.XC_MethodReplacement;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.XSharedPreferences;
import java.util.regex.Pattern;
</#if>
/*
	注意！
	你需要关掉Instant Run才能在Android Studio里使用“运行App”，不然Xposed会出现找不到类的错误。
	Be Awared!
	You should disable Instant Run if you want to use 'Run App' from Android Studio, or Xposed Framework will not find module class from base.apk.
	https://developer.android.com/studio/run/#disable-ir
*/

public class ${className} implements IXposedHookLoadPackage<#if select == "selector">, IXposedHookZygoteInit</#if> {

	<#if select == "specify">
	String targetApp="${targetApp}";
	<#elseif select == "selector">
    public static XSharedPreferences sPrefs;
	String targetApp;
	boolean isReg;
	</#if>
    String packageName;
    Boolean isFirstApplication;
    ClassLoader classLoader;
    String processName;
    ApplicationInfo appInfo;
    
	@Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam loadPackageParam) throws Throwable {
		<#if select == "specify">
		if(!loadPackageParam.packageName.equals(targetApp))return;
		<#elseif select == "selector">
        sPrefs.reload();
        targetApp = sPrefs.getString("hookee","${targetApp}");
        isReg = sPrefs.getBoolean("isReg",false);
		if (loadPackageParam.packageName.equals("${packageName}")){
			XposedHelpers.findAndHookMethod("${packageName}.${className}Selector", loadPackageParam.classLoader, "isModuleActive", XC_MethodReplacement.returnConstant(true));
            if(Build.VERSION.SDK_INT>=26)XposedHelpers.findAndHookMethod("android.app.ContextImpl", loadPackageParam.classLoader, "checkMode", int.class, XC_MethodReplacement.returnConstant(null));
        }
		if(!shouldHook(loadPackageParam.packageName))return;
		</#if>
		gatherInfo(loadPackageParam);
		//Write your code here.
		
		
		
    }
    <#if select == "selector">
    @Override
    public void initZygote(StartupParam startupParam) throws Throwable {
        sPrefs = new XSharedPreferences(this.getClass().getPackage().getName(),"${className}Selector");
        sPrefs.makeWorldReadable();
    }
    </#if>
    private void gatherInfo(XC_LoadPackage.LoadPackageParam loadPackageParam){
        packageName=loadPackageParam.packageName;
        isFirstApplication=loadPackageParam.isFirstApplication;
        classLoader=loadPackageParam.classLoader;
        processName=loadPackageParam.processName;
        appInfo=loadPackageParam.appInfo;
    }
	<#if select == "selector">
    private boolean shouldHook(String packageName){
        if (isReg) {
            Pattern pattern = Pattern.compile(targetApp);
            if (pattern.matcher(packageName).matches()) return true;
        } else {
            if (packageName.equals(targetApp)) return true;
        }
        return false;
    }
	</#if>
}
