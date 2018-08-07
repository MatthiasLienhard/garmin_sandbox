using Toybox.WatchUi as Ui;
using Toybox.System as Sys;



class LineGraph
{
    hidden var minRange;
    hidden var color;
    hidden var topLeft;
    hidden var bottomRight;

    //! Constructor
    function initialize( graphMinRange, graphColor , topLeft, bottomRight)
    {
        self.minRange=graphMinRange;
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
        var minMax=getRange(data, 0, data.size());
        
        var range;
        var y;
        var x;
        var prev_y;
        var prev_x;
        var drawExtentsX = self.bottomRight[0] - self.topLeft[0] + 1;
        var drawExtentsY = self.bottomRight[1] - self.topLeft[1] + 1;
        		
        // If the graph range is null, no values have been added yet
        if( minMax[0] != null )
        {
        	if(minMax[1]-minMax[0]<self.minRange){
        		var delta=self.minRange-(minMax[1]-minMax[0]);
        		minMax[0]-=delta/2;
        		minMax[1]+=delta/2;
        	}
        	range = (minMax[1] - minMax[0]).toFloat();
        	
            //Set Graph color       !!!no way to preserve color setting right now?
            dc.setColor(self.color, self.color);
            
            x=null;
            y=null;
            //for( i = graphIndex ; i < graphArray.size() ; i += 1 )
            for( var n = 0 ; n < data.size() ; n += 1 )
            {
                
            	var i=(n+idx+1)%data.size();
                if( data[i] != null ){
                    prev_y = y;
                    prev_x = x;
                    //Sys.println(bottomRight[1]+" - (("+data[i]+" - "+data[0]+") * "+drawExtentsY+" / "+range+")");
                    y = (bottomRight[1] - ((data[i] - minMax[0]) * drawExtentsY / range)).toNumber();
                    x = topLeft[0] + drawExtentsX * n / (data.size() - 1);
                    if(prev_x != null){
                    	dc.drawLine(prev_x, prev_y, x, y);
                    }
                }
            }
        }
    }
}
