package ${packageName}.extend;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.content.Context;

import java.util.HashMap;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class Timing {
    HashMap<String,XC_MethodHook.Unhook> unhooks=new HashMap<String,XC_MethodHook.Unhook>();
    public Timing(XC_LoadPackage.LoadPackageParam loadPackageParam){
        this(loadPackageParam,false);
    }
    public Timing(XC_LoadPackage.LoadPackageParam loadPackageParam, final Boolean isOnce){
        try {
            unhooks.put("onNewActivity"
                    ,XposedBridge.hookMethod(XposedHelpers
                            .findClass("android.app.Instrumentation", loadPackageParam.classLoader)
                                    .getDeclaredMethod("newActivity"
                                            ,java.lang.ClassLoader.class
                                            ,java.lang.String.class
                                            ,Intent.class)
                    ,new XC_MethodHook() {
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            if(isOnce)unhooks.remove("onNewActivity").unhook();
                            onNewActivity(param);
                        }
                    })
            );
            unhooks.put("afterNewActivity"
                    ,XposedBridge.hookMethod(XposedHelpers
                            .findClass("android.app.Instrumentation", loadPackageParam.classLoader)
                            .getDeclaredMethod("newActivity"
                                    , java.lang.ClassLoader.class
                                    , java.lang.String.class
                                    , Intent.class)
                            ,new XC_MethodHook() {
                        protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                            if(isOnce)unhooks.remove("afterNewActivity").unhook();
                            afterNewActivity((Activity) param.getResult());
                        }
                    })
            );
            unhooks.put("onNewApplication"
                    ,XposedBridge.hookMethod(XposedHelpers
                            .findClass(loadPackageParam.appInfo.className, loadPackageParam.classLoader)
                            .getDeclaredMethod("onCreate")
                            , new XC_MethodHook() {
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            if (isOnce) unhooks.remove("onNewApplication").unhook();
                            onNewApplication((Application) param.thisObject);
                        }

                    })
            );
            unhooks.put("afterNewApplication"
                    ,XposedBridge.hookMethod(XposedHelpers
                            .findClass(loadPackageParam.appInfo.className, loadPackageParam.classLoader)
                            .getDeclaredMethod("onCreate")
                            ,new XC_MethodHook() {
                        protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                            if(isOnce)unhooks.remove("afterNewApplication").unhook();
                            afterNewApplication((Application) param.thisObject);
                        }

                    })
            );
            unhooks.put("onAttachBaseContext"
                    , XposedBridge.hookMethod(XposedHelpers
                                    .findClass("android.content.ContextWrapper", loadPackageParam.classLoader)
                                    .getDeclaredMethod("attachBaseContext"
                                            , Context.class)
                            , new XC_MethodHook() {
                                protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                                    if (isOnce) unhooks.remove("onAttachBaseContext").unhook();
                                    onAttachBaseContext((Context) param.args[0]);
                                }
                            })
            );
            unhooks.put("afterAttachBaseContext"
                    , XposedBridge.hookMethod(XposedHelpers
                                    .findClass("android.content.ContextWrapper", loadPackageParam.classLoader)
                                    .getDeclaredMethod("attachBaseContext"
                                            , Context.class)
                            , new XC_MethodHook() {
                                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                                    if (isOnce) unhooks.remove("afterAttachBaseContext").unhook();
                                    afterAttachBaseContext((Context) param.args[0]);
                                }
                            })
            );			
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
    protected void onNewActivity(XC_MethodHook.MethodHookParam param){}
    protected void afterNewActivity(Activity activity){}
    protected void onNewApplication(Application application){}
    protected void afterNewApplication(Application application){}
    protected void onAttachBaseContext(Context context) {}
    protected void afterAttachBaseContext(Context context) {}
}