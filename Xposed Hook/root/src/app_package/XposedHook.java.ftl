package ${packageName};

import java.lang.reflect.Member;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
<#if hookType == "net">
import fi.iki.elonen.NanoHTTPD;
</#if>

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
    int port;
    String server;
	
    public MyXposedHook() {
        this(6666);
    }
    ${hookName}(int port){
        if(port!=0)this.port=port;
        server = "http://127.0.0.1:"+ port;
        new Server(this.port);
    }
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
    /**
     * @description: Hook specified method.
     *
     * @author: Monkeylord
     **/
    public void hook(Member method){
        XposedBridge.hookMethod(method, this);
    }
	/**
     * @description: Hook all methods in given class, which match given RegExpression.
     *
     * @author: Monkeylord
     **/
    public void hook(Class clz,String methodRegEx){
        Pattern pattern=Pattern.compile(methodRegEx);
        for (Member method:clz.getDeclaredMethods()) {
            if(pattern.matcher(method.getName()).matches())hook(method);
        }
    }
    /**
     * @description: If the given class is loaded, hook all matched methods in given class, if not, wait until it load, then hook all matched methods in given class. Warning: It's performance-costly.
     *
     * @author: Monkeylord
     **/
    public void hook(String clz, final String methodRegEx, ClassLoader classLoader){
        final String clzn=clz;
        try {
            Class clazz=Class.forName(clz,false,classLoader);
            hook(clazz,methodRegEx);
        } catch (ClassNotFoundException e) {
            //XposedBridge.log(clzn+" not Found,waiting.");
            final ArrayList<Unhook> unhooks=new ArrayList<>();
            unhooks.add(XposedHelpers.findAndHookMethod("java.lang.ClassLoader", classLoader, "loadClass", String.class, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    super.afterHookedMethod(param);
                    String clazz=(String) param.args[0];
                    if(clazz.equals(clzn)){
                        if(param.getResult()!=null){
                            //XposedBridge.log(clzn+" loaded, hooking");
                            hook((Class)param.getResult(),methodRegEx);
                            unhooks.get(0).unhook();
                        }
                    }
                }
            }));
        }
    }
    private void gatherInfo(MethodHookParam param){
        method=param.method;
        thisObject=param.thisObject;
        args=param.args;
    }
<#if hookType == "net">
	class Server extends NanoHTTPD {
        public Server(int port) {
            super(port);
            try {
                start(0, false);
                XposedBridge.log("${hookName} Listening on " + port);
            } catch (Exception e) 
            {
                XposedBridge.log("${hookName} Fail Listening on " + port);
                e.printStackTrace();
            }
        }
        @Override
        public Response serve(String uri, Method method, Map<String, String> headers, Map<String, String> parms, Map<String, String> files) {
            return NanoHTTPD.newFixedLengthResponse(files.get("postData"));
        }
    }
</#if>
}
