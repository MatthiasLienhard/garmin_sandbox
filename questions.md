# Questions related to garmin connectiq
* timer
    * what is the maximal frequency (for all different devices)?
    * what happens if calculations/ UI update take more time?
    * why is Time limited on seconds?
* sensors (accelerometer, magnetometer and barometer)
    * do sensors have regular update intervals or does this depend on load.
    * what is the (typical) update frequency for different devices in Sensor.info /Activity.info
    * sensor_listener seems to be able to record accelerometer data at higher frequency
        * up to what frequency for  which device?
        * is there a way to add magnet and (raw ambient) barometer data?            
* gps position 
    * position from position callback and automatic (generic profile) fit recording is off (about 1 meter, most of the time by a constant) - why? 
        * Semicircle calculation? 
        * Earth radius constant?
    * how exactly is position calculated (filtered / "enhanced" if signal is poor)
"If no GPS is available or is between GPS fix intervals (typically 1 second), the position is propagated (i.e. dead-reckoned) using the last known heading and last known speed. After a short period of time, the position will cease to be propagated to avoid excessive accumulation of position errors."

        * how is speed and heading calculated and can that be influenced?
        * what information is used (in addition to the gps data)
        * does this depend on device/ fit recording mode?
        * In open water swimming (generic profile fit recording), vivoactive HR produces a strange error distribution, with alterating error in heading direction
    * is there a way to get 
        * "raw" (unfiltered) gps data
        * measure for accuracy
        * influence position calculation (e.g. by providing a speed estimate)
        swimStrokeType
* Fit file recording
    * by setting a profile, many values are saved automatically. Is there a way to supress that, e.g. to 
        * save storage
        * avoid calculation of the measures
        * replace values (e.g. speed / heigth ) by own estimates
        * record values at different frequencies
* swimming metrics
    * can I get the stroke count/ swimming type?
    * type: Activity.info.swimStrokeType (only few devices - why?)
    * strokes: ???
    
        
        
    