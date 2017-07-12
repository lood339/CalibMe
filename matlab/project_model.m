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






