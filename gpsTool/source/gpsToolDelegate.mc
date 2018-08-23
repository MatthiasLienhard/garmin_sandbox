using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;

class gpsToolDelegate extends Ui.InputDelegate {
	var prevPos;
	var time;
	var timer;
	var dist;
	var count;
	var vibe;
	var accuracy;
	const freq=20;
	const R=6371000;

    function initialize() {
		InputDelegate.initialize();
		self.timer = new Timer.Timer();
		self.time=0;
		self.count=0;
		self.dist=[0,0];
		self.accuracy=0;
    	vibe=[new Attention.VibeProfile(100, 200)]; // On for 1/5 second
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));

    }
	
	function onKey(keyEvent) {
    	var key=keyEvent.getKey();
        //System.println("Key press: "+ key.toString());         // e.g. KEY_MENU = 7
        if (key ==7){
        	onMenu(); 
        }else if (key ==4){
        	onEnter(); 
        }
        
    }
    function onMenu() {
     	return true;
    }
    
    // use the get new gps position
	function onEnter() {
		self.time=0;
		self.timer.start(method(:timeCB), (1000/self.freq).toNumber(),true);		
		Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition2));
		//Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
	}

	function timeCB(){
		self.time+=1;
	}
	function onPosition2(info){
		onPosition(info);
		self.count+=1;
		self.timer.stop();
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
	}
	function onPosition(info){
		if (info has :position && info.position != null && info.accuracy>1) {
			
			//Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
			var pos=info.position.toRadians();
			self.dist=getDistMeter(pos);	
			self.accuracy=info.accuracy;		
			prevPos=pos;
			
			Attention.vibrate(vibe);
			Ui.requestUpdate();
		}else{
			Sys.println("signal not good");
		}

		
	}
	function getDistMeter(pos){ 
        if (self.prevPos != null){
        	return [(pos[0]-self.prevPos[0]) * R , 
					(pos[1]-self.prevPos[1]) * R * Math.cos(pos[0])];
        } else{
            return [0,0];
        }
    }
}
