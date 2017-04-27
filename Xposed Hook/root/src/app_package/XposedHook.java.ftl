package ${packageName};

import java.lang.reflect.Member;
import java.util.regex.Pattern;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * Hook's type: ${hookType}
 * Usage:
 *		in XposedModule 
 *		new ${hookName}.hook(Method);
 *	or	new ${hookName}.hook(Class,MethodRegx);
 */
public class ${hookName} extends XC_MethodHook {
    public Member method;			//被Hook的方法
    public Object thisObject;		//方法被调用时的this对象
    public Object[] args;			//方法被调用时的参数
    private Object result = null;	//方法被调用后的返回结果
    @Override
    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
		gatherInfo(param);
        //Write your code here.
<#if hookType == "trace">
        XposedBridge.log("Method:" + method.getName().toString());
        for (Object arg:args) {
            XposedBridge.log("  Arg:"+arg.toString());
        }
</#if>
<#if hookType == "net">
        for (int i = 0; i < args.length; i++) {
            //TODO Override this with your own handler
            if(args[i] instanceof String)
                args[i]=new netUtil(server+"/"+method.getName()+"_Arg"+i,args[i].toString()).getRet();
            else{
                //手动处理非String对象
            }
        }
</#if>
    }

    @Override
    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
        gatherInfo(param);
        result=param.getResult();
        //Write your code here.
		
<#if hookType == "trace">
        XposedBridge.log("Method:"+method.getName().toString());
        XposedBridge.log("  Result:"+result.toString());
</#if>
<#if hookType == "net">
        //TODO Override this with your own handler
        result=new netUtil(server+"/"+method.getName()+"_Result",result.toString()).getRet();
        param.setResult(result);
</#if>

        //You can replace it's result by uncomment this
        //param.setResult(result);
		
		
    }

    public void hook(Member method){
        XposedBridge.hookMethod(method, this);
    }
    public void hook(Class clz,String methodRegEx){
        Pattern pattern=Pattern.compile(methodRegEx);
        for (Member method:clz.getDeclaredMethods()) {
            if(pattern.matcher(method.getName()).matches())hook(method);
        }
    }

    private void gatherInfo(MethodHookParam param){
        method=param.method;
        thisObject=param.thisObject;
        args=param.args;
    }
}
