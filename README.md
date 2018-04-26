# XposedTemplateForAS
自动化创建Xposed模块及钩子，让Xposed模块编写时只需关注钩子实现。

These templates automatically create Xposed Module and Hooks, helping module coder focusing on essential implement.

## 模版安装/How to Install
将模板文件夹（注意不是GIT文件夹）放置在
Android Stuido安装位置\plugins\android\lib\templates\other
然后重启AS

Copy templates(not the whole git project) to [Android Stuido Install Path]\plugins\android\lib\templates\other

Then, restart Android Studio.

## 模版使用/How to Use
在write your code处写钩子内容实现即可。

Implement your hook at "write your code".

### 创建模块/Create Module
新建空工程->右键New->Xposed->Xposed Module

Create a new project

right click your package ->New -> Xposed -> Xposed Module

### 创建方法钩子/Create Hook
右键New->Xposed->Xposed Hook

right click your package ->New -> Xposed -> Xposed Hook

#### 跟踪方法调用-Tracer

用于方法函数，将方法的参数及结果在Xposed日志中打印。

A pre-made hook designed to print argruments&result in XposedBridge.Log

#### 动态修改参数结果-GS_Net

用于动态篡改方法的参数和结果，使用方法见内部说明。

A pre-made hook designed to dynamically modify arguments&result with a help of an HTTP server.

### 时机模板/Timing

方便在应用启动、界面启动等时机注入，使用方法：

Help you to inject your code on other timing.(eg. onApplicationAttach)

~~~java
new Timing(loadPackageParam,true){
    @Override
    protected void onApplicationAttach(Context context) {
        super.onApplicationAttach(context);
        //do sth
    }
    //还可以实现其他时机对应的方法
};
~~~