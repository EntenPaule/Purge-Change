; toolchange from [current_extruder] to [next_extruder], layer [layer_num]
;before tool change
M106 S0 ;turn off fan
G92 E0 ;turn off retraction
G1 E-0.8 F2100 ;retract

GG91 ;change in relative position
{if layer_z <= 25}
  G1 Z25 F1000; z-lift if lower than 25 mm
{endif}

G1 Y105 X230 F12000 ;break filament before lifting
;G1  F12000 ;move head to position


G90 ;transition to absolute position

G4 S0 ;clean up buffer movement
G1 X240 ;move head to purge area
G1 X245 F2000
G1 X252.35 F1000 ;extend the buscket
;*end of pre-tool change gcode

; Start cleaning the filament before extraction
; material : PLA
;--------------------;

M220 B ; turn aux v1.0.5
M220 S100 ; change of loading tool
 
;if you have a problem of peak it is here that it is necessary to modify

G1 E-15.0000 F7200
G1 E-24.5000 F1200
M73 Q84 S16
G1 E-7.0000 F600
G1 E-3.5000 F360

{if layer_num == 1}
   M140 S[first_layer_temperature] ; set the extruder temperature to 215 degrees - first layer
 {endif}

{if layer_num > 1}
  M104 S[first_layer_temperature] ; set the extruder temperature to 210 degrees - other layers
 {endif}

G1 E20.0000 F339 ; extrude 20mm at a speed of 339
G1 E-20.0000 F226 ; extrude -20mm at a speed of 226
M73 Q43 S3 ; extrude 20mm at a speed of 339
M73 P43 R3 ; indicate to the firmware percentage in normal mode 43 and time remaining in this position 3
G1 E-35.0000 F2000 ; retract -35mm at a speed of 2000
G4 S0 ; pause the machine

;end of modification of the action on the spikes

;---------------;

T{next_extruder} ;tool change

;start the purge after changing the tool
M107 ;turn off the fan
G92 E0 ;reset the position of the extrusion
G1 E12 F400 ;filament support
G1 E60 F1000 ;acceleration for nozzle descent
G1 E50 F200 ;nozzle purge
M106 S255 ;turn on the fan
G4 S5 ;cool the ball
G92 E0 ;reset the position of the extrusion
G1 E-0.8 F2100 ;retract to avoid seepage

{if layer_num == 1}
  M107 ;turn off fan
 {endif}

M73 Q34 S64
G1 X252.35 F3000 ;ball ejection movement
G1 X230 F12000 ;buscket go back home

;end of tool purge gcode