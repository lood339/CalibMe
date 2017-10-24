clear
close all

addpath('/home/ritazhu/sports/vanishing_point');

load('ratio_vertical_line.mat');

load('ratio_horizontal_line.mat');
ratio_line = ratio_vertical_line;
load('79_vp.mat'); 
im = imread('79.jpg');
figure;
imshow(im);
hold on

% click from left to right or top to bottom
[x,y] = ginput(3);

% horizontal/vertival vanishing point location
% vp(1)&vp(2) is intersaction of horizontal lines; vp(3)&vp(4) is intersaction of vertical lines
vp = [vp(1),vp(2)];


% assume vanishing point is in the leftmost or top
d1 = pdist([x(3),y(3);vp(1),vp(2)]);% distance between vanishing point and x1
d2 = pdist([x(1),y(1);x(3),y(3)]);% distance between x2 and x3
d3 = pdist([x(2),y(2);vp(1),vp(2)]);% distance between vanishing point and x2
d4 = pdist([x(1),y(1);x(2),y(2)]);% distance between x1 and x3
r = (d1*d4) / (d2*d3);

threshold = 0.02;

for i = 1:size(ratio_line,1)
    if abs(r - ratio_line(i,2)) < threshold
        line_idx = ratio_line(i,1);
    end
end