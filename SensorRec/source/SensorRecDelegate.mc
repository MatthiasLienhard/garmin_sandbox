using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attention;


class SensorRecDelegate extends Ui.InputDelegate {
	var session;

	var vibeStart;
	var vibeStop;
	
    function initialize(session) {
    	self.session=session;
    	vibeStart=[
		        new Attention.VibeProfile(100, 200), // On for 1/5 second
		        new Attention.VibeProfile(0, 200),  // Off for 1/5 second
		        new Attention.VibeProfile(50, 200), // On for 1/5 second
		        new Attention.VibeProfile(0, 200),  // Off for 1/5 second
		        new Attention.VibeProfile(100, 200)  // on for 1/5 second
		    ];
		    vibeStop=[new Attention.VibeProfile(50, 1000)]; // On for 1 second
        InputDelegate.initialize();
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
     	//Sys.println("onMenu");
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
		//Sys.println("Enter");		
		if (Toybox has :ActivityRecording) {
			if (!session.isRecording()){
		       	session.start();       
		        Attention.vibrate(vibeStart);		           
		    } else {
		    	//session.setBlip();
				session.save();  
				Attention.vibrate(vibeStop);	
            	Ui.requestUpdate();
			}   
		}   
		return true; 
	}
	function teardown(){
		if (session.isRecording()) {
			session.save();                                      
			Attention.vibrate(vibeStop);
		}
		session=null;			
	}
}
