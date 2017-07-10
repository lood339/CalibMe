% project model line
clear
close all

% camera parameter
camera = [640.000000	 360.000000	 2986.943295	 1.367497	 -1.082443	 0.980122	 -16.431519	 14.086604	 5.580546];
u = camera(1);
v = camera(2);
f = camera(3);
rod = camera(4:6); % Rodrigues angle
c = camera(7:9);

K = [f, 0, u; 0, f, v; 0, 0, 1];
rotation = rotationVectorToMatrix(rod);

% projection matrix
P = K * [rotation, c'];


% @todo Load soccer field model

% @todo project soccer field model to image

% @visualize the model in the image



