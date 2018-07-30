package ${packageName};

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.List;

public class ${className}Selector extends Activity {
    SharedPreferences sp;
    String hookee;
    boolean isReg;
    TextView info;
    EditText appname;
    CheckBox regEx;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LinearLayout layout=new LinearLayout(this);
        LinearLayout.LayoutParams param=new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.FILL_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        layout.setOrientation(LinearLayout.VERTICAL);
        super.setContentView(layout,param);
        sp=getPreferences(MODE_WORLD_READABLE);
        hookee=sp.getString("hookee","com.");
        isReg=sp.getBoolean("isReg",false);
        final AppAdapter appAdapter=new AppAdapter(this);
        final AlertDialog selector=new AlertDialog.Builder(this)
                .setTitle("Select App")
                .setAdapter(appAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        hookee=((PackageInfo)appAdapter.getItem(i)).packageName;
                        update();
                        dialogInterface.dismiss();
                    }
                })
                .create();
		TextView welcome = new TextView(this);
        welcome.setText("${moduleName}'s App Selector");
        welcome.setTextSize(20f);
        welcome.setTextColor(Color.BLACK);
        info=new TextView(this);
        appname=new EditText(this);
        regEx=new CheckBox(this);
        regEx.setText("use RegEx");
        Button apply=new Button(this);
        apply.setText("Apply");
        apply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                hookee=appname.getText().toString();
                isReg=regEx.isChecked();
                update();
            }
        });
        Button selectApp=new Button(this);
        selectApp.setText("Select App");
        selectApp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selector.show();
            }
        });
        if(!isModuleActive()){
            TextView alert=new TextView(this);
            alert.setText("Be Awared: Module Inactive");
            alert.setTextColor(Color.RED);
            layout.addView(alert);
        }
        layout.addView(welcome);
        layout.addView(info);
        layout.addView(appname);
        layout.addView(regEx);
        layout.addView(apply);
        layout.addView(selectApp);
        update();
    }
    private static boolean isModuleActive() {
        return false;
    }
    public void update(){
        SharedPreferences.Editor editor=sp.edit();
        editor.putString("hookee",hookee);
        editor.putBoolean("isReg",isReg);
        editor.commit();
        info.setText("Current Hookee App:\r\n"+hookee);
        appname.setText(hookee);
        regEx.setChecked(isReg);
    }
    class AppAdapter extends BaseAdapter{
        Context context;
        List<PackageInfo> packageInfo;
        AppAdapter(Context context){
            this.context=context;
            packageInfo=context.getPackageManager().getInstalledPackages(0);
        }
        @Override
        public int getCount() {
            return packageInfo.size();
        }
        @Override
        public Object getItem(int i) {
            return packageInfo.get(i);
        }
        @Override
        public long getItemId(int i) {
            return 0;
        }

        @Override
        public View getView(int i, View view, ViewGroup viewGroup) {
            RelativeLayout relativeLayout=new RelativeLayout(context);
            relativeLayout.setLayoutParams(new AbsListView.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            ImageView iv=new ImageView(context);
            iv.setImageDrawable(packageInfo.get(i).applicationInfo.loadIcon(context.getPackageManager()));
            TextView tv=new TextView(context);
            tv.setPadding(80,0,0,0);
            tv.setText(packageInfo.get(i).applicationInfo.loadLabel(context.getPackageManager())+"\r\n"+packageInfo.get(i).packageName);
            relativeLayout.addView(iv);
            relativeLayout.addView(tv);
            return relativeLayout;
        }
    }
}
