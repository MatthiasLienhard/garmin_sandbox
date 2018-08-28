
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.ActivityRecording;
using Toybox.SensorLogging;
using Toybox.FitContributor as Fit;
using Toybox.Math;
using Toybox.Time;
using Toybox.Attention as Attention;

class owSwimDelegate extends WatchUi.BehaviorDelegate{
	var session;
    function initialize(s) {
		session=s;
        BehaviorDelegate.initialize();
    }
    
    function onMenu() {
        if( Toybox has :ActivityRecording ) {
            if( ! session.isRecording() ) {
                if (session.hasGPS()){
				    session.startRecording();
                }
            }
            else{
				session.stopRecording();
            }
        }
        return true;
    }
}

