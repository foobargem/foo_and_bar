package com.suddenlybunt.toprider.sms;

import android.os.Bundle;

import com.phonegap.DroidGap;

public class MainActivity extends DroidGap {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.main);
        
        
        String wwwDir;
        
        // ToDo:
        wwwDir = "ing";
        //wwwDir = "before";
        
        super.setIntegerProperty("splashscreen", R.drawable.splash);

        super.loadUrl("file:///android_asset/www/"+ wwwDir +"/index.html");
    }
}
