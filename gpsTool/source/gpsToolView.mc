using Toybox.WatchUi as Ui;
using Toybox.System;


class gpsToolView extends Ui.View {
	var delegate;
	var width;
	var height;

    function initialize(delegate) {
		System.println("init view");       
		View.initialize();
        self.delegate=delegate;
		 
    }

	function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        width = dc.getWidth();
        height = dc.getHeight();
    }

	function onUpdate(dc) {
		//if (delegate.prevPos != null){
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK );
			dc.clear();
			dc.drawText( width/2,   height/4.5, Graphics.FONT_TINY, 
				"lat: "+delegate.dist[0].format("%1.2f")+"m\n"+
				"lng: " +delegate.dist[1].format("%1.2f")+"m\n"+
				"accuracy: " +delegate.accuracy+"\n"+
				"time: "+(delegate.time.toFloat()/delegate.freq).format("%1.2f")+" sec\n"+
				"count: "+delegate.count, Graphics.TEXT_JUSTIFY_CENTER);
		//}
	}
}
