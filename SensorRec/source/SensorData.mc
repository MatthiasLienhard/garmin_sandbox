using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.Timer as Timer;
using Toybox.WatchUi as Ui;

class SensorData {
	const recordTime=4;
	const sampleFreq=15;
	const N=recordTime*sampleFreq;
	const R=6371000 ;//earth radius [m]
	var accelX = new [N];
	var accelY = new [N];
	var accelZ = new [N];
	var magX = new [N];
	var magY = new [N];
	var magZ = new [N];
	var pressure = new [N];
	var pos= new[recordTime];
	var posAcc= new[recordTime];
	var posTime=new[recordTime];
	var sensorIdx;
	var posIdx;
	var sensorTimer;
	var recording;
	var ret=new[sampleFreq];
	var i;
    // Constructor
    function initialize() {
    	recording=false;
    	sensorIdx=N-1;
    	posIdx=recordTime-1;
    	sensorTimer = new Timer.Timer();
        sensorTimer.start(method(:sensorCallback), 1000/sampleFreq, true);
        for(i =0;i<N;i+=1){
        	accelX[i]=0;
        	accelY[i]=0;
        	accelZ[i]=0;
        	magX[i]=0;
        	magY[i]=0;
        	magZ[i]=0;
			pressure[i]=0;
        }
        for(i =0;i<recordTime;i+=1){
        	pos[i]=new Position.Location({:latitude => 0, :longitude => 0, :format => :semicircles });
        	posAcc[i]=0;
        	posTime[i]=0;
        }
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:positionCallback));
	    //Sensor.registerSensorDataListener(method(:accel_callback), options);
	    //Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]); this is only for some (e.g. bike) but not pressure and magnet
        
    }
    function teardown(){
		sensorTimer.stop();
		Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:positionCallback));
     
    }
    function setRecording(state){
    	self.recording=state;
    	return true;
    }
    function isRecording(){
    	return(self.recording);
    }
    
    function getAccelX(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=accelX[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    function getAccelY(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=accelY[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    function getAccelZ(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=accelZ[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    function getMagX(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=magX[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }    
    function getMagY(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=magY[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    function getMagZ(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=magZ[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    
    function getPressure(){
    	for(var i=0;i<sampleFreq;i+=1){
    		ret[i]=pressure[(sensorIdx+i)%N ];
    	}
    	return(ret);
    }
    function getPosSemicircles(){
    	if(pos[posIdx] != null ) {
    		var coords=pos[posIdx].toRadians();    	
        	coords[0] = ((coords[0] * 0x80000000l)/Math.PI).toNumber();
        	coords[1] = ((coords[1] * 0x80000000l)/Math.PI).toNumber();
        	return(coords);		    	
    	}else{
    		return([0, 0]);
    	}
    }
    function getPosRadians(){    	
    	if(pos[posIdx] != null ) {
    		return(pos[posIdx].toRadians());
    	}else{
    		return(["NA", "NA"]);
    	}
    }  
    function getPosMeter(){ 
       	var prevIdx=(posIdx-1);
    	if(prevIdx<0){prevIdx=recordTime-1;}    	
    	if(pos[posIdx] != null && pos[prevIdx] != null) {
    		var pos1=pos[posIdx].toRadians();
    		var pos2=pos[prevIdx].toRadians();
    		var dist=[(pos2[0]-pos1[0]) * R , (pos2[1]-pos1[1]) * R * Math.cos(pos1[0])];
    		return(dist);
    	}else{
        	return([0,0]);
        }
    }      
    function getPosAcc(){
    	var acc=posAcc[posIdx];
    	if (acc == null){
    		acc=0;
    	}
    	return(acc);
    }
    function getPosTime(){
    	var t=posTime[posIdx];
    	if (t == null){
    		t=0;
    	}
    	return(t);
    }
    
    
    
    function positionCallback(info){
    	var prevIdx=posIdx;
    	posIdx+=1;
		if(posIdx==recordTime){
			posIdx=0;
		}
		if (info has :position && info.position != null) {
			//System.println("Latitude: " + info.position[:latitute]); // e.g. 38.856147
		    posTime[posIdx]=sensorIdx;
		    pos[posIdx]=info.position;
		    posAcc[posIdx]=info.accuracy;
		    /*
		    var coords = info.position.toRadians();
            pos[0] = ((coords[0] * 0x80000000l)/Math.PI).toNumber();
            pos[1] = ((coords[1] * 0x80000000l)/Math.PI).toNumber();
			System.println("Latitude: " + pos[0]); 
    		System.println("Longitude: " + pos[1]);
    		System.println("Time: "+posTime);
    		*/	
		} else{
			posTime[posIdx]=posTime[prevIdx]-sampleFreq;
			pos[posIdx]=pos[prevIdx];
			posAcc[posIdx]=posAcc[prevIdx];
		}

	}
	function sensorCallback() {        
		var ainfo = Activity.getActivityInfo();
		var info = Sensor.getInfo();
		var prevIdx=sensorIdx;
		sensorIdx+=1;
        if(sensorIdx==N){
        	sensorIdx=0;
        }        	
        if (info has :accel && info.accel != null) {
        	//The accelerometer reading of the x, y, and z axes as an Array of Number values in millig-units
            accelX[sensorIdx]=info.accel[0];
            accelY[sensorIdx]=info.accel[1];
            accelZ[sensorIdx]=info.accel[2];
        } else {
        	accelX[sensorIdx]=accelX[prevIdx];
            accelY[sensorIdx]=accelY[prevIdx];
            accelZ[sensorIdx]=accelZ[prevIdx];
        
        }
        if (info has :mag && info.mag != null) {
        	//The magnetometer reading of the x, y, and z axes as an Array of Number values in millig-units
            magX[sensorIdx]=info.mag[0];
            magY[sensorIdx]=info.mag[1];
            magZ[sensorIdx]=info.mag[2];            
        }else{
       		magX[sensorIdx]=magX[prevIdx];
            magY[sensorIdx]=magY[prevIdx];
            magZ[sensorIdx]=magZ[prevIdx];    
        
        }
        
        if (ainfo has :rawAmbientPressure && ainfo.rawAmbientPressure != null) {
        	pressure[sensorIdx]=ainfo.rawAmbientPressure;
        }else {
        	pressure[sensorIdx]=pressure[prevIdx];
        } 
        Ui.requestUpdate();
        
    }    
}
