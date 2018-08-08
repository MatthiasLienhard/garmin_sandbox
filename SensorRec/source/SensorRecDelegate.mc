using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;


class SensorRecDelegate extends Ui.InputDelegate {
	var session;
	var data;
	var vibeStart;
	var vibeStop;
	
    function initialize(d) {
    	self.data=d;
    	self.session=null;
    	vibeStart=[
		        new Attention.VibeProfile(50, 200), // On for 1/5 second
		        new Attention.VibeProfile(0, 200),  // Off for 1/5 second
		        new Attention.VibeProfile(50, 200), // On for 1/5 second
		        new Attention.VibeProfile(0, 200),  // Off for 1/5 second
		        new Attention.VibeProfile(50, 200)  // on for 1/5 second
		    ];
		    vibeStop=[new Attention.VibeProfile(50, 1000)]; // On for 1 second
        InputDelegate.initialize();
    }
    
	function onKey(keyEvent) {
    	var key=keyEvent.getKey();
        System.println("Key press: "+ key.toString());         // e.g. KEY_MENU = 7
        if (key ==7){
        	onMenu(); 
        }else if (key ==4){
        	onEnter(); 
        }
        
    }

    function onMenu() {
     	Sys.println("onMenu");
    	/*
    	if (Toybox has :ActivityRecording) {
			if (session.isRecording() == false) {  
        		// Ui.pushView(new Rez.Menus.MainMenu(), new SensorRecMenuDelegate(), Ui.SLIDE_UP);
        		session.start();    
        	}else {
				
			}      		
        }
        */	
        return true;
    }
    
    // use the select Start/Stop or touch for recording
	function onEnter() {
		Sys.println("Enter");		
		if (Toybox has :ActivityRecording) {                          // check device for activity recording
			if (session==null){
				session=new SensorSession(data);
		       	session.start();                                     // call start session
		        Attention.vibrate(vibeStart);		           
		    } else if ((session != null) && session.isRecording()) {
		    	//session.setBlip();
		       	session.stop();                                      // stop the session
				session.save();                                      // save the session
				Attention.vibrate(vibeStop);
				session=null;
			}   
		}   
		return true;                                        // return true for onSelect function
	}
	function teardown(){
		if ((session != null) && session.isRecording()) {
			session.stop();                                      // stop the session
			session.save();                                      // save the session
			Attention.vibrate(vibeStop);
			session=null;
			
		}
	}
}