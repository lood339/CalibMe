function project_model(camera, model_points, model_line_segment, rgb_image)
% project a 2D field model to the image space
% camera: 9 camera parameters, (u, v, focal_length, Rx, Rx, Rz, Cx, Cy, Cz)
%         (Rx, Rx, Rz): is Rodrigues angle, (Cx, Cy, Cz) unit in meter
% model_points: N x 2 matrix, model world coordinate in meter
% model_line_segment: line segment index, start from 1
% rgb_image: an RGB image
% example: 
% camera = [640.000000	 360.000000	 2986.943295	 1.367497	 -1.082443	 0.980122	 -16.431519	 14.086604	 5.580546];
% I = imread('00003600.jpg');
% load('soccer_field_model.mat');
% model_points = points;
% model_line_segment = line_segment_index + 1;
% project_model(camera, model_points, model_line_segment, I);
assert(length(camera) == 9);
assert(size(model_points, 2) == 2);
assert(size(model_line_segment, 2) == 2);
assert(size(rgb_image, 3) == 3);

% 
u = camera(1);
v = camera(2);
f = camera(3);
rod = camera(4:6); % Rodrigues angle
c = camera(7:9)';

K = [f, 0, u; 0, f, v; 0, 0, 1];
rotation = rotationVectorToMatrix(rod)'; % camera rotation to world point rotation

N = size(model_points, 1);
image_points = zeros(N, 2);

for i = [1:N]
    p = [model_points(i, 1), model_points(i, 2), 0.0]';
    % translate, rotate, then project
    p = K*rotation*(p - c);
    x = p(1)/p(3);
    y = p(2)/p(3);  % p(3) may be zero
    image_points(i, :) = [x, y];    
end

% draw projected model on the image
figure; imshow(rgb_image);
hold on;
idx1 = model_line_segment(:, 1); % linesegment start index
idx2 = model_line_segment(:, 2); % linesegment end index
x = [image_points(idx1, 1), image_points(idx2, 1)];
y = [image_points(idx1, 2), image_points(idx2, 2)];
plot(x', y', 'r');

end
%{
%% project model line
clear
close all

%% camera parameter
camera = [640.000000	 360.000000	 2986.943295	 1.367497	 -1.082443	 0.980122	 -16.431519	 14.086604	 5.580546];
u = camera(1);
v = camera(2);
f = camera(3);
rod = camera(4:6); % Rodrigues angle
c = camera(7:9);

K = [f, 0, u; 0, f, v; 0, 0, 1];
rotation = rotationVectorToMatrix(rod)';

% Load soccer field model
load('soccer_field_model.mat');

%% projection matrix : P = K * rotation * (X - c)

% project soccer field model to image
pointsIn3D = zeros(354,3);
for j = 1 : 354
    pointsIn3D(j,1) = points(j,1) - c(1,1);
    pointsIn3D(j,2) = points(j,2) - c(1,2);
    pointsIn3D(j,3) = - c(1,3);
end 

pointsProjected1 = K * rotation * pointsIn3D';
pointsProjected = pointsProjected1';

% transfer to 2D space
pointsProjected(:,1) = pointsProjected(:,1) ./  pointsProjected(:,3);
pointsProjected(:,2) = pointsProjected(:,2) ./  pointsProjected(:,3);

%% visualize the model in the image
I = imread('00003600.jpg');
image(I);
hold on

% plot points
for i = 1:354
 plot(pointsProjected(i,1),pointsProjected(i,2),'*r');
 hold on 
end

set(gca,'Ydir','reverse');
xlim([0 size(I,2)]);
ylim([0 size(I,1)]);


% plot lines
for k = 1:size(line_segment_index,1)
    if(pointsProjected(line_segment_index(k,1)+1,1) >= 0 && pointsProjected(line_segment_index(k,1)+1,1) <= size(I,2) && pointsProjected(line_segment_index(k,1)+1,2) >= 0 && pointsProjected(line_segment_index(k,1)+1,2) <= size(I,1))
        plot([pointsProjected(line_segment_index(k,1)+1,1),pointsProjected(line_segment_index(k,2)+1,1)],[pointsProjected(line_segment_index(k,1)+1,2),pointsProjected(line_segment_index(k,2)+1,2)],'b');
        hold on
    end
end
%}






