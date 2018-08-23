//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Application;
using Toybox.Position;
using Toybox.System;

class owSwimApp extends Application.AppBase {

    var mSession;
	

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    //! We need to enable the location events for now so that we make sure GPS
    //! is on.
    function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
        mSession.stopRecording();
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
		mSession.onPosition(info);
    }

    //! Return the initial view of your application here
    function getInitialView() {
		mSession= new owSwimSession();
        return [ new owSwimView(mSession), new owSwimDelegate(mSession)];
    }

}
