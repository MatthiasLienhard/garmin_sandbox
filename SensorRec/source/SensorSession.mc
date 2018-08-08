
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Sensor;
using Toybox.Math as Math;
//using Toybox.SensorLogging as SensorLogging;
using Toybox.ActivityRecording as Record;
using Toybox.Activity as Activity;
using Toybox.System as System;
using Toybox.FitContributor as Fit;
using Toybox.Position as Position;
using Toybox.Timer as Timer;
//using Toybox.Attention as Attention;
//using Toybox.Lang;

/*
class AllSensorLogger extends SensorLogging.SensorLogger{
	function initialize(options){
	    //options={:period => 1, :sampleRate => 25, :enableAccelerometer => true}
		SensorLogging.SensorLogger.initialize(options);	
		// if (options has ...)
		//can I add support for compas and raw pressure??
	}

}
*/

class SensorSession { //extends ActivityRecording.Session{
	var mSession;
	var mLogger;
	var sessionData;
	var idx=0;
	
	var accelXField;
    var accelYField;
    var accelZField;
    var magneXField;
    var magneYField;
    var magneZField;
    var pressuField;        
	var gpsLatField;
	var gpsLngField;
	var gpsAccField;
	var gpsTimeField;
	var sectionField;
	var logTimer;

    // Constructor
    function initialize(data) {
        
        try {
        	sessionData=data;
            //mLogger = new SensorLogging.SensorLogger({:enableAccelerometer => true}); //also enable pressure and compass ???
            mSession = Record.createSession({:name=>"SensorRecording", :sport=>Record.SPORT_GENERIC}); //, :sensorLogger => mLogger});
            gpsLatField=mSession.createField("gps_lat", 0, Fit.DATA_TYPE_SINT32, {:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD});
            gpsLngField=mSession.createField("gps_lng", 1, Fit.DATA_TYPE_SINT32, {:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD});
            gpsAccField=mSession.createField("gps_accuracy", 2, Fit.DATA_TYPE_SINT16, { :mesgType=>Fit.MESG_TYPE_RECORD});
            gpsTimeField=mSession.createField("gps_time", 3, Fit.DATA_TYPE_SINT16, { :mesgType=>Fit.MESG_TYPE_RECORD});            
            accelXField=mSession.createField("accel_X", 4, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            accelYField=mSession.createField("accel_Y", 5, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            accelZField=mSession.createField("accel_Z", 6, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            magneXField=mSession.createField("mag_X", 7, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            magneYField=mSession.createField("mag_Y", 8, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            magneZField=mSession.createField("mag_Z", 9, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            pressuField=mSession.createField("pressure",10, Fit.DATA_TYPE_FLOAT , {:units=>"Pa", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>SensorData.sampleFreq});
            sectionField=mSession.createField("section", 11, Fit.DATA_TYPE_UINT8 , {:mesgType=>Fit.MESG_TYPE_RECORD});	
            logTimer = new Timer.Timer();
        
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }
    
	
    // Start Sensor logger
    function start() {
        // initialize accelerometer
        // var options = {:period => 1, :sampleRate => 25, :enableAccelerometer => true};
	    try {        	
	      	mSession.start();
	      	
	      	logTimer.start(method(:setData), 1000, true);
	      	setData();	  
	      	sessionData.setRecording(true);  	
	    } catch(e) {
	        System.println(e.getErrorMessage());
	     
        }
    }
    
	    
	function setData(){
		System.println("new data");
		var values=sessionData.getAccelX();
		System.println("new x "+ values);
		accelXField.setData(sessionData.getAccelX());
        accelYField.setData(sessionData.getAccelY());
        accelZField.setData(sessionData.getAccelZ());
        magneXField.setData(sessionData.getMagX());
        magneYField.setData(sessionData.getMagY());
        magneZField.setData(sessionData.getMagZ());
        pressuField.setData(sessionData.getPressure());
        var pos=sessionData.getPosSemicircles();
        System.println("new pos"+ pos);
		gpsLatField.setData(pos[0]);
		gpsLngField.setData(pos[1]);
		gpsAccField.setData(sessionData.getPosAcc());
		gpsTimeField.setData(sessionData.getPosTime());
		
	}

    function stop() {        
        if ( mSession != null && self.isRecording()){
        	logTimer.stop();
        	mSession.stop();
        	sessionData.setRecording(false);  	
        	
        	
        }
        
    }
    function isRecording() {
    	/*
    	try{
    		return(mSession.isRecording());
    	}catch(e){
    		return (false);
    	}
    	*/
    	return sessionData.isRecording();
    }
    
    function save(){
        mSession.save();     
        self.stop();
    }
    
}