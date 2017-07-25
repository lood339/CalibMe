% matrix from pan Y then tilt X
function m = panYTiltX(pan, tilt)
pan = pan *pi/180.0;
tilt = tilt *pi/180.0;
R_tilt = [1, 0, 0; 
          0, cos(tilt), sin(tilt); 
          0, -sin(tilt), cos(tilt)];
R_pan = [cos(pan), 0, -sin(pan);
         0, 1, 0; 
         sin(pan), 0, cos(pan)];
m = R_tilt * R_pan;
end