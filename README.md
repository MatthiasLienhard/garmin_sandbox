# garmin_sandbox

## Fit file analysis
* What information is in FIT files by Garmin App/Swim Pro from the ConnectIQ store
* Depict these infos
* Analyse
## Watch Apps

 Tests with garmin monkeyc to develop an open water swimming app for the vivoactive HR
### First recording App:
Look how sensor data look like
* record accelerometer data
* record position together with accuracy
* other sensor data that are "for free"
    * kompas (magnetometer)
    * pressure (helps with stroke?)
    * temperatur?
    * heart rate (any options? raw?)

    
### Open water swimming App:
Fit file recording
* interval
    * 1/sec (or less) vs 1/stroke?
* phases in swimming:
    * start/end/transition/pause detection
* swim stroke counter for front crawl in open water (without laps)
    * access to garmin algorithm?
    * use accel/magnet/pressure/temperature sensors
    * also provide kinematic measures/parameters (e.g. time for individual phases of the stroke)
        * i:  entry
        * ii: outsweep
        * iii: catch 
        * iv: insweep
        * v: upsweep 
        * vi exit
        * vii: mid-recovery
    * later: other styles?
* GPS smoothing/dropout filter in water
    * use accuracy to filter / as weight for smoothing
    * timing of measurement aligned to stroke?
    * if signal is poor: also use "normal" stroke distance?
    * at worst: take start and end - asume steight line
    * LQE: https://en.wikipedia.org/wiki/Kalman_filter
* recording of HR in water
    * issues?
    * filtered/smoothed/postprocessed?


