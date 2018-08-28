//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

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

class owSwimView extends WatchUi.View {
	var session;
    function initialize(s) {
		session=s;
        View.initialize();

    }


    //! Load your resources here
    function onLayout(dc) {
    }


    function onHide() {
    }

    //! Restore the state of the app and prepare the view to be shown.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Set background color
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_XTINY, "M:"+System.getSystemStats().usedMemory, Graphics.TEXT_JUSTIFY_CENTER);

        if( Toybox has :ActivityRecording ) {
            // Draw the instructions
            if( ! session.isRecording() ) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
				if (session.hasGPS()){
	                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    	        }else{
					dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Waiting\nfor GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
				}
            } else {
                var x = dc.getWidth() / 2;
                var y = dc.getFontHeight(Graphics.FONT_XTINY);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
                dc.drawText(x, y, Graphics.FONT_MEDIUM, "Recording...", Graphics.TEXT_JUSTIFY_CENTER);
                y += 1.5*dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
  				dc.drawText(x, y, Graphics.FONT_MEDIUM, "time: "+session.getRecTime()+" s",Graphics.TEXT_JUSTIFY_CENTER);
                y += dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.drawText(x, y, Graphics.FONT_MEDIUM, "speed: "+session.getSpeed().format("%1.2f")+" km/h",Graphics.TEXT_JUSTIFY_CENTER);
                y += dc.getFontHeight(Graphics.FONT_MEDIUM);
				dc.drawText(x, y, Graphics.FONT_MEDIUM, "dist: "+session.total_dist.format("%1.2f")+" m",Graphics.TEXT_JUSTIFY_CENTER);

				y += 1.5*dc.getFontHeight(Graphics.FONT_MEDIUM);
 				dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);               
                dc.drawText(x, y, Graphics.FONT_MEDIUM, "Press Menu again\nto Stop and Save", Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
        
    }

}
