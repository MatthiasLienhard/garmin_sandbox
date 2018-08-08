using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class SensorRecApp extends App.AppBase {
	var session;
	var delegate;
	
    function initialize() {
        AppBase.initialize();        
    }

    // onStart() is called on application start up
    function onStart(state) {       
    	session=new SensorSession();
    }
	
	
    // onStop() is called when your application is exiting
    function onStop(state) {    
    	delegate.teardown();        
    }

    // Return the initial view of your application here
    function getInitialView() {
    	delegate=new SensorRecDelegate(session);

    	return [ new SensorRecView(session), delegate];
    }

}
