# XposedTemplateForAS
自动化创建Xposed模块及钩子，让Xposed模块编写时只需关注钩子实现。

## 模版安装
将模板文件夹（注意不是GIT文件夹）放置在
Android Stuido安装位置\plugins\android\lib\templates\other
然后重启AS

## 模版使用
在write your code处写钩子内容实现即可。
### 创建模块
新建空工程->右键New->Xposed->Xposed Module
### 创建方法钩子
右键New->Xposed->Xposed Hook

#### 预制钩子-Tracer

用于方法函数，将方法的参数及结果在Xposed日志中打印。

#### 预制钩子-GS_Net

用于动态篡改方法的参数和结果，使用方法见内部说明。

### 时机模板

方便在应用启动、界面启动等时机注入，使用方法：

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