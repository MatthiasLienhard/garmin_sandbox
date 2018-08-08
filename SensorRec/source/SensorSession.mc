
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
	const N=15; // sampling Frequency	
	const R=6371000 ;//earth radius [m]
	var mSession;
	//var mLogger;
	var sessionData;
	var idx;
	var accelX;
	var accelY;
	var accelZ;
	var magX;
	var magY;
	var magZ;
	var pressure;
	var prevPos;
	var posAccuracy;
	var dist;
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
    var recording;
    var sensorTimer;
    // Constructor
    function initialize() {
        
        try {
        	recording=false;
            //mLogger = new SensorLogging.SensorLogger({:enableAccelerometer => true}); //also enable pressure and compass ???
            sensorTimer = new Timer.Timer();
            dist=[0,0];
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }
    
	
    // Start Sensor logger
    function start() {
        // initialize accelerometer
        // var options = {:period => 1, :sampleRate => 25, :enableAccelerometer => true};
        mSession = Record.createSession({:name=>"SensorRecording", :sport=>Record.SPORT_GENERIC}); //, :sensorLogger => mLogger});
        gpsLatField=mSession.createField("gps_lat", 0, Fit.DATA_TYPE_SINT32, {:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD});
        gpsLngField=mSession.createField("gps_lng", 1, Fit.DATA_TYPE_SINT32, {:units=>"semicircles", :mesgType=>Fit.MESG_TYPE_RECORD});
        gpsAccField=mSession.createField("gps_accuracy", 2, Fit.DATA_TYPE_SINT16, { :mesgType=>Fit.MESG_TYPE_RECORD});
        gpsTimeField=mSession.createField("gps_time", 3, Fit.DATA_TYPE_SINT16, { :mesgType=>Fit.MESG_TYPE_RECORD});            
        accelXField=mSession.createField("accel_X", 4, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        accelYField=mSession.createField("accel_Y", 5, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        accelZField=mSession.createField("accel_Z", 6, Fit.DATA_TYPE_SINT16 , {:units=>"millig", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        magneXField=mSession.createField("mag_X", 7, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        magneYField=mSession.createField("mag_Y", 8, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        magneZField=mSession.createField("mag_Z", 9, Fit.DATA_TYPE_SINT16 , {:units=>"mG", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        pressuField=mSession.createField("pressure",10, Fit.DATA_TYPE_UINT16 , {:units=>"Pa", :mesgType=>Fit.MESG_TYPE_RECORD,:count=>N});
        sectionField=mSession.createField("section", 11, Fit.DATA_TYPE_UINT8 , {:mesgType=>Fit.MESG_TYPE_RECORD});	
        mSession.start();
        idx=0;
        initData();
        sensorTimer.start(method(:sensorCallback), (1000/N).toNumber(),true);
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:positionCallback));
	    self.recording=true;
	    
	    
    }
    function teardown(){
        sensorTimer.stop();
  		Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:positionCallback));
    }

    function stop() {   
        if ( mSession != null && self.recording()){
        	
        	mSession.stop();
        	teardown();
        	mSession=null;
        	self.recording=false;
        }
        
    }
    function initData(){
        accelX = new [N];
	    accelY = new [N];
	    accelZ = new [N];
	    magX = new [N];
	    magY = new [N];
	    magZ = new [N];
	    pressure = new [N];
	}
	
    function save(){
        mSession.save();  
    	teardown();
        mSession=null;
        self.recording=false;
    }

    function isRecording() {
    	return self.recording;
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
    	    
	function setData(){
		System.println("new data: "+accelX);		
  		accelXField.setData(accelX);
        accelYField.setData(accelY);
        accelZField.setData(accelZ);
        magneXField.setData(magX);
        magneYField.setData(magY);
        magneZField.setData(magZ);
        pressuField.setData(pressure);
        /*
        var pos=getPosSemicircles();
        System.println("new pos"+ pos);
		gpsLatField.setData(pos[0]);
		gpsLngField.setData(pos[1]);
		gpsAccField.setData(sessionData.getPosAcc());
		gpsTimeField.setData(sessionData.getPosTime());
		*/
		
	}
    function positionCallback(info){
    	if (info has :position && info.position != null) {
			//System.println("Latitude: " + info.position[:latitute]); // e.g. 38.856147

		    var pos=radToSemicircles(info.position.toRadians());
		    self.dist=getDistMeter(info.position);
            //System.println("new pos"+ pos);
		    gpsLatField.setData(pos[0]);
		    gpsLngField.setData(pos[1]);
		    self.posAccuracy=info.accuracy;
		    gpsAccField.setData(info.accuracy);
		    gpsTimeField.setData(idx);
		    prevPos=info.position;
            Ui.requestUpdate();
		} 
	}
    function sensorCallback() {        
		var ainfo = Activity.getActivityInfo();
		var info = Sensor.getInfo();
		var prevIdx=idx;
        if (info has :accel && info.accel != null) {
        	//The accelerometer reading of the x, y, and z axes as an Array of Number values in millig-units
            //System.println("Accel"+info.accel);
            accelX[idx]=info.accel[0];
            accelY[idx]=info.accel[1];
            accelZ[idx]=info.accel[2];
        } 
        if (info has :mag && info.mag != null) {
        	//The magnetometer reading of the x, y, and z axes as an Array of Number values in millig-units
            magX[idx]=info.mag[0];
            magY[idx]=info.mag[1];
            magZ[idx]=info.mag[2];            
        }
        
        if (ainfo has :rawAmbientPressure && ainfo.rawAmbientPressure != null) {
        	pressure[idx]=ainfo.rawAmbientPressure;
        }
  		idx+=1;
        if(idx==N){
        	idx=0;
        	self.setData();
        	self.initData();
        }        	       
    }    

}
