using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

using Toybox.Time as Time;
//using Toybox.Time.Gregorian as Calendar;
class SensorRecView extends Ui.View {

	var acc_x_graph;
	var acc_y_graph;
	var acc_z_graph;
	var mag_x_graph;
	var mag_y_graph;
	var mag_z_graph;
	var press_graph;
	var width;
	var height;
	var data;
    function initialize(d) {
        View.initialize();
        data=d;
        
        
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        width = dc.getWidth();
        height = dc.getHeight();
        var h=(height-4)/4.5;
        acc_x_graph = new LineGraph( 300, Gfx.COLOR_RED,    [ 2,    20], [width,  h-1] );
        acc_y_graph = new LineGraph( 300, Gfx.COLOR_GREEN,  [ 2,    20], [width,  h-1] );
		acc_z_graph = new LineGraph( 300, Gfx.COLOR_BLUE,   [ 2,    20], [width,  h-1] ); 
        mag_x_graph = new LineGraph( 100, Gfx.COLOR_RED,    [ 2,  h+20], [width,2*h-1] );
        mag_y_graph = new LineGraph( 100, Gfx.COLOR_GREEN,  [ 2,  h+20], [width,2*h-1] );
		mag_z_graph = new LineGraph( 100, Gfx.COLOR_BLUE,   [ 2,  h+20], [width,2*h-1] ); 
		press_graph = new LineGraph( 100, Gfx.COLOR_ORANGE, [ 2,2*h+20], [width,3*h-1] ); 
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
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        acc_x_graph.draw( dc, data.accelX, data.sensorIdx); //vivoactive HR: 148x204 pixel
        acc_y_graph.draw( dc,  data.accelY, data.sensorIdx);
        acc_z_graph.draw( dc,  data.accelZ, data.sensorIdx);
        mag_x_graph.draw( dc,  data.magX, data.sensorIdx); 
        mag_y_graph.draw( dc,  data.magY, data.sensorIdx); 
        mag_z_graph.draw( dc,  data.magZ, data.sensorIdx); 
        press_graph.draw( dc,  data.pressure, data.sensorIdx);
        var pos=data.getPosMeter();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        dc.drawText( width/2,   height/4.5*3, Gfx.FONT_TINY, "lat:"+pos[0].format("%1.2f")+"m\nlng:" +pos[1].format("%1.2f")+"m\nAccuracy level: "+data.getPosAcc(), Gfx.TEXT_JUSTIFY_CENTER);
        if(data.isRecording() && Time.now().value() % 2 == 0){//Calendar.info(Time.now(), Time.FORMAT_MEDIUM_SHORT)){
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED );
        	dc.fillCircle( width/10*9,height-width/20-2,width/20 );
        }
        
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
