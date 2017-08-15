clear
close all

pp = [1280/2, 720/2];
cc = [113.41, 2.22, 6.03];
base_rotation = [1.278234, 1.118293, -1.103959];
camera = [3676.645334	 1.688016	 0.454302	 -0.371234	 113.410000	 2.220000	 6.030000];
ptz = camera2PTZ(cc, base_rotation, camera); 

% from ptz to camera
camera1 = ptz_to_camera(ptz, pp, cc, base_rotation);

norm(camera - camera1(3:9))