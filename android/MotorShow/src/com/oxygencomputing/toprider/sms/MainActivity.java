package com.oxygencomputing.toprider.sms;

import java.util.Calendar;
import java.util.TimeZone;

import android.os.Bundle;

import com.phonegap.DroidGap;

public class MainActivity extends DroidGap {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.main);
        
        super.setIntegerProperty("splashscreen", R.drawable.splash);
        super.loadUrl("file:///android_asset/www/"+ wwwDir() +"/index.html");
    }
    
    
    protected String wwwDir() {
    	TimeZone tz = TimeZone.getTimeZone("Asia/Seoul");
    	Calendar openDay = Calendar.getInstance(tz);
    	openDay.set(2011, 3, 1); // 2011.04.01
    	
    	Calendar today = Calendar.getInstance(tz);
    	    	
    	String wwwDir = "ing";
    	if (today.compareTo(openDay) < 0) {
    		wwwDir = "before";
    	}

    	// for testing
    	//wwwDir = "ing";
    	
    	return wwwDir;
    }
    
}
