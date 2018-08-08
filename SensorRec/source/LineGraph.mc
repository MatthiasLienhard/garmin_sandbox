using Toybox.WatchUi as Ui;
using Toybox.System as Sys;



class LineGraph
{
    hidden var range;
    hidden var color;
    hidden var topLeft;
    hidden var bottomRight;
    hidden var fixedRange;

    //! Constructor
    function initialize(  topLeft, bottomRight, graphRange, fixedRange, graphColor )
    {
        self.range=graphRange;
        self.fixedRange=fixedRange;
        self.color=graphColor;
        self.topLeft=topLeft;
        self.bottomRight=bottomRight;
        
    }

    //! Set graph line color
    function setColor( graphColor ) {
        color=graphColor;
    }
	hidden function getRange(values, from, to){
		//returns [min, max] of array
		var range=new [2];
		range[0]=values[from];
		range[1]=values[from];
		for(var  i = from+1 ; i < to ; i += 1 ){
			if (values[i]!= null){
				if (values[i]<range[0]){
					range[0]=values[i];
				}else if(values[i]>range[1]){
					range[1]=values[i];
				}
			}
		}
		
		return (range);
	}

    //! Handle the update event
    function draw(dc, data, idx)
    {   
        var currentRange=self.range    
        if(! self.fixedRange){
            currentRange=getRange(data, 0, data.size());
            if(currentRange[0]>range[0]){
                currentRange[0]=range[0];
            }
            if(currentRange[1]<range[1]){
                currentRange[1]=range[1];
            }
        }       
        
        //var range;
        var y;
        var x;
        var prev_y;
        var prev_x;
        var drawExtentsX = self.bottomRight[0] - self.topLeft[0] + 1;
        var drawExtentsY = (self.bottomRight[1] - self.topLeft[1] + 1)/(currentRange[1]-currentRange[0]);
        		
        dc.setColor(self.color, self.color);
        x=null;
        y=null;
        for( var n = 0 ; n < data.size() ; n += 1 ) {
         	var i=(n+idx)%data.size();
            if( data[i] != null ){
                prev_y = y;
                prev_x = x;
                //Sys.println(bottomRight[1]+" - (("+data[i]+" - "+data[0]+") * "+drawExtentsY+" / "+range+")");
                y = (bottomRight[1] - ((data[i] - currentRange[0]) * drawExtentsY)).toNumber();
                x = topLeft[0] + drawExtentsX * n / (data.size() - 1);
                if(prev_y != null){
                  	dc.drawLine(prev_x, prev_y, x, y);
                
                }
            }
        }
    }
}
