
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
	var vibe;
    var validGPS;
	const R=6371000 ;//earth radius [m]

	var stroke_count=0;
	var minStrokeDuration=500; //ms

	function initialize() {
		vibe=[new Attention.VibeProfile(100, 200)]; // On for 1/5 second
        validGPS=false;
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
		}else if(info.accuracy ==4){
            validGPS=true;
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
    function hasGPS(){
        return(validGPS);
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
				Attention.vibrate(vibe);
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
				:sport=>5, //swimming 
				:subsport=>18, //open water swimming
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
			Attention.vibrate(vibe);
		}catch(e) {			
		    System.println("Error in start recording: "+e.getErrorMessage());
		}
        WatchUi.requestUpdate();
	}
}



