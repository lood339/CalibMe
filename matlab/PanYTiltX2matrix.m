function m = PanYTiltX2matrix(pan,tilt)
% pan,tilt: the degree of angle
    pan = deg2rad(pan);
    tilt = deg2rad(tilt);
    
    R_tilt = zeros(3,3);
    R_tilt(2,2) = cos(tilt);
    R_tilt(2,3) = sin(tilt);
    R_tilt(3,2) = -sin(tilt);
    R_tilt(3,3) = cos(tilt);
    
    R_pan = zeros(3,3);
    R_pan(1,1) = cos(pan);
    R_pan(1,3) = -sin(pan);
    R_pan(2,2) = 1;
    R_pan(3,1) = sin(pan);
    R_pan(3,3) = cos(pan);
    
    m = R_tilt * R_pan;
end