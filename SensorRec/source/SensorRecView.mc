using Toybox.WatchUi as Ui;
using Toybox.Graphics;

using Toybox.Time as Time;
//using Toybox.Time.Gregorian as Calendar;
class SensorRecView extends Ui.View {

	var width;
	var height;
	var session;
	var dot;
    function initialize(session) {
        View.initialize();
        self.session=session;
        self.dot=false;
        
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        width = dc.getWidth();
        height = dc.getHeight();
     }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
                   	//update graph 
		//dc.setClip(x, y, width, height)
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
		dc.clear();
        if(session.isRecording()) {
	        var pos=session.dist;
	        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
	        dc.drawText( width/2,   height/4.5, Graphics.FONT_TINY, "lat:"+pos[0].format("%1.2f")+"m\nlng:" +pos[1].format("%1.2f")+"m\nAccuracy level: "+session.posAccuracy, Graphics.TEXT_JUSTIFY_CENTER);

			if(self.dot){
	        	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED );
    	    	dc.fillCircle( width/10*9,height-width/20-2,width/20 );
			}
			self.dot=!self.dot;
        }else{
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
			dc.drawText( width*2/3,   height*3/4.5, Graphics.FONT_TINY, "Press button to\nstart recording", Graphics.TEXT_JUSTIFY_CENTER);
		}

        
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
