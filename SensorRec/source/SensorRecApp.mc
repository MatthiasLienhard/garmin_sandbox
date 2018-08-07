using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class SensorRecApp extends App.AppBase {
	//var session;
	var view;
	var data;
	var delegate;
	
    function initialize() {
        AppBase.initialize();        
    }

    // onStart() is called on application start up
    function onStart(state) {       
    	data=new SensorData();
    }
	
	
    // onStop() is called when your application is exiting
    function onStop(state) {    
    	delegate.teardown();
        data.teardown();
        
    }

    // Return the initial view of your application here
    function getInitialView() {
    	//session=new SensorSession(data);
    	view = new SensorRecView(data);
    	delegate=new SensorRecDelegate(data);
        return [ view, delegate];
    }

}
