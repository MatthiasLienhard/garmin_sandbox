//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.ActivityRecording;
using Toybox.SensorLogging;
using Toybox.FitContributor as Fit;
using Toybox.Math;
using Toybox.Time;

class owSwimSession {
	var session = null;
	var mX = [0];
    var mY = [0];
    var mZ = [0];
	var mYaw=[0];
	var mPitch=[0];
	var mRoll=[0];
	var prevPos;
	var mLogger;
	var last_pos_time=null;
	var rec_start_time=null;
	var gpsLatField;
	var gpsLngField;
	var total_dist=0;
	var last_dist=0;
	var speed=0;

	const R=6371000 ;//earth radius [m]

	var stroke_count=0;
	var minStrokeDuration=500; //ms

	function initialize() {
		mLogger = new SensorLogging.SensorLogger({:enableAccelerometer => true});
	}
    function accel_callback(sensorData) {
        mX = sensorData.accelerometerData.x;
        mY = sensorData.accelerometerData.y;
        mZ = sensorData.accelerometerData.z;
		mYaw=sensorData.accelerometerData.power;
		mPitch=sensorData.accelerometerData.pitch;
		mRoll=sensorData.accelerometerData.roll;	

        onAccelData();
    }
	function onAccelData(){
		//compute stroke count here;
		
	}
	function onPosition(info) {
		//smooth/filter position
		if(isRecording()){
			var now=Time.now();
			var dt=11;
			if(last_pos_time!= null){
				dt=now.subtract(last_pos_time).value();
			}
			if(dt >= 10){
				var pos=radToSemicircles(info.position.toRadians());
				//self.dist=getDistMeter(info.position);
				//System.println("new pos"+ pos);
				gpsLatField.setData(pos[0]);
				gpsLngField.setData(pos[1]);
				var dist=getDistMeter(info.position);
				
				last_dist=Math.sqrt(Math.pow(dist[0], 2)+Math.pow(dist[1], 2));
				speed=last_dist/1000*60/dt*60;
				total_dist+=last_dist;
				last_pos_time=now;
				prevPos=info.position;
			}
		}
		WatchUi.requestUpdate();
    }
	function radToSemicircles(coords){
    	var semic=[((coords[0] * 0x80000000l)/Math.PI).toNumber(),
             	   ((coords[1] * 0x80000000l)/Math.PI).toNumber()];
        return(semic);		    	    	
    }
    
    function getDistMeter(pos){ 
        if (self.prevPos != null){
           	var pos1=pos.toRadians();
        	var pos2=self.prevPos.toRadians();
        	return [(pos2[0]-pos1[0]) * R , (pos2[1]-pos1[1]) * R * Math.cos(pos1[0])];
        } else{
            return [0,0];
        }
    }

	function isRecording(){
		return( session != null && session.isRecording());
	}
	function getRecTime(){
		if(isRecording()){
			return(Time.now().subtract(rec_start_time).value());
		}else{
			return(0);	
		}
	}
	function getSpeed (){
		if(isRecording()){
			return(speed);	
		}else{
			return(0);	
		}
	}
	function stopRecording(){
		System.println("stop recording");
        if( Toybox has :ActivityRecording ) {
            if( isRecording() ) {
				Sensor.unregisterSensorDataListener();
                session.stop();
                session.save();
                session = null;
                WatchUi.requestUpdate();
				return (true);
            }
        }
		return (false);
    }
	
	function startRecording() {
		System.println("start recording");
		try {			
		    session = ActivityRecording.createSession({
				:name=>"Open Water Swim", 
				:sport=>ActivityRecording.SPORT_SWIMMING, 
				:subsport=>ActivityRecording.SUB_SPORT_OPEN_WATER, 
				:sensorLogger => mLogger});
			gpsLatField=session.createField("position_lat", 0, Fit.DATA_TYPE_SINT32, 
				{:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD, :nativeNum=>0});
		    gpsLngField=session.createField("position_long", 1, Fit.DATA_TYPE_SINT32, 
				{:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD, :nativeNum=>1});
	  		// initialize accelerometer
			var options = {:period => 1, :sampleRate => 25, :enableAccelerometer => true};
				//:includePower => true, includePitch => true,:includeRoll => true};		
			rec_start_time=Time.now();
			Sensor.registerSensorDataListener(method(:accel_callback), options);
		    session.start();
		}catch(e) {			
		    System.println("Error in start recording: "+e.getErrorMessage());
		}
        WatchUi.requestUpdate();
	}
}


class owSwimDelegate extends WatchUi.BehaviorDelegate{
	var session;
    function initialize(s) {
		session=s;
        BehaviorDelegate.initialize();
    }
    
    function onMenu() {
        if( Toybox has :ActivityRecording ) {
            if( ! session.isRecording() ) {
				session.startRecording();
            }
            else{
				session.stopRecording();
            }
        }
        return true;
    }
}

class owSwimView extends WatchUi.View {
	var session;
    function initialize(s) {
		session=s;
        View.initialize();

    }


    //! Load your resources here
    function onLayout(dc) {
    }


    function onHide() {
    }

    //! Restore the state of the app and prepare the view to be shown.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Set background color
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_XTINY, "M:"+System.getSystemStats().usedMemory, Graphics.TEXT_JUSTIFY_CENTER);

        if( Toybox has :ActivityRecording ) {
            // Draw the instructions
            if( ! session.isRecording() ) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
            else {
                var x = dc.getWidth() / 2;
                var y = dc.getFontHeight(Graphics.FONT_XTINY);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
                dc.drawText(x, y, Graphics.FONT_MEDIUM, "Recording...", Graphics.TEXT_JUSTIFY_CENTER);
                y += 1.5*dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
  				dc.drawText(x, y, Graphics.FONT_MEDIUM, "time: "+session.getRecTime()+" s",Graphics.TEXT_JUSTIFY_CENTER);
                y += dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.drawText(x, y, Graphics.FONT_MEDIUM, "speed: "+session.getSpeed().format("%1.2f")+" km/h",Graphics.TEXT_JUSTIFY_CENTER);
                y += dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.drawText(x, y, Graphics.FONT_MEDIUM, "dist: "+session.total_dist.format("%1.2f")+" m",Graphics.TEXT_JUSTIFY_CENTER);

				y += 1.5*dc.getFontHeight(Graphics.FONT_MEDIUM);
 				dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);               
                dc.drawText(x, y, Graphics.FONT_MEDIUM, "Press Menu again\nto Stop and Save", Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
        
    }

}
