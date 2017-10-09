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
<#if hookType == "net">
	String server="http://192.168.1.1:8000";//注意：将此处改为PC端IP与端口
</#if>
    @Override
    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
		gatherInfo(param);
        //Write your code here.
<#if hookType == "trace">
        log("<"+method.getDeclaringClass()+" method="+MethodDescription(param).toString()+">");
        try {
            for (int i=0;i<args.length;i++) {
                log("<Arg index="+ i + ">" + translate(args[i])+"</Arg>");
            }
        }catch (Throwable e){
            log("<Error>"+e.getLocalizedMessage()+"</Error>");
        }finally {
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
        try {
            log("<Result>" + translate(result)+"</Result>");
        }catch (Throwable e){
            log("<Error>"+e.getLocalizedMessage()+"</Error>");
        }finally {
            log("</"+method.getDeclaringClass()+" method="+MethodDescription(param).toString()+">");
        }
</#if>
<#if hookType == "net">
        //TODO Override this with your own handler
        result=new netUtil(server+"/"+method.getName()+"_Result",result.toString()).getRet();
        param.setResult(result);
</#if>

        //You can replace it's result by uncomment this
        //param.setResult(result);
		
		
    }
<#if hookType == "trace">
    private void log(String log){
        //You can add your own logger here.
        //e.g filelogger like Xlog.log(log);
        XposedBridge.log(log);
    }
    private String MethodDescription(MethodHookParam param){
        StringBuilder sb=new StringBuilder();
        sb.append(method.getName().toString());
        sb.append("(");
        for (Object arg:args) {
            if(arg==null)sb.append("UnknownType");
            else if(arg.getClass().isPrimitive())sb.append(arg.getClass().getSimpleName());
            else sb.append(arg.getClass().getName());
            sb.append(",");
        }
        sb.append(")");
        return sb.toString();
    }
    private String translate(Object obj){
        //Write your translator here.
        return obj.toString();
    }
</#if>
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
