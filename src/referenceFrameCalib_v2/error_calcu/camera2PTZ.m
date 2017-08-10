function [ptz] = camera2PTZ(cc, base_rotation, camera)
% pan, tilt and focal length from camera parameter
% cc: camera center, this should be the same as the camera center
% base_rotation: camera base rotation in form of rodrigues angle
% camera: 7 x 1 focal_length, rotation in rodtrigues, Camera center xyz
% return: pan, tilt (degrees) and focal length (pixels)
% example:
% cc = [113.41, 2.22, 6.03];
% base_rotation = [1.278234, 1.118293, -1.103959];
% camera = [3676.645334	 1.688016	 0.454302	 -0.371234	 113.410000	 2.220000	 6.030000];
% ptz = camera2PTZ(cc, base_rotation, camera); 
% result is 52.6696, -8.96654, 3676.65
assert(length(cc) == 3);
assert(length(base_rotation) == 3);
assert(length(camera) == 7);

fl = camera(1);
rod = camera(2:4);
camera_cc = camera(5:7);
base_r_inv = inv(rotationVectorToMatrix(base_rotation)'); % 
camera_r = rotationVectorToMatrix(rod)';
r_pan_tilt = camera_r*base_r_inv;

cc_dis = norm(cc - camera_cc);
assert(cc_dis <= 0.0001); % camera center should close to common camera center


cos_pan = r_pan_tilt(1, 1);
sin_pan = -r_pan_tilt(1, 3);
cos_tilt = r_pan_tilt(2, 2);
sin_tilt = -r_pan_tilt(3, 2);
pan  = atan2(sin_pan, cos_pan) * 180.0 /pi;
tilt = atan2(sin_tilt, cos_tilt) * 180.0 /pi;

ptz = zeros(3, 1);
ptz(1) = pan;
ptz(2) = tilt;
ptz(3) = fl;
                            
end
