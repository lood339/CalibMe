clear 
close all

addpath('/home/ritazhu/sports/vanishing_point');
load('gt_17.mat');
h = camera_to_homography(camera);

minX=inf;
maxX=-inf;
minY=inf;
maxY=-inf;

im = imread('17.jpg');
% im1 = padarray(im,[500 7000],255);
figure;
imshow(im);
hold on
% plot(0,0,'*r');
% hold on
% 
% minX=min(minX,0);
% maxX=max(maxX,0);
% minY=min(minY,0);
% maxY=max(maxY,0);

x1 = h(1,1) / h(3,1);
y1 = h(2,1) / h(3,1);
plot(x1,y1,'*r');
hold on

minX=min(minX,x1);
maxX=max(maxX,x1);
minY=min(minY,y1);
maxY=max(maxY,y1);

x2 = h(1,2) / h(3,2);
y2 = h(2,2) / h(3,2);
plot(x2,y2,'*r');
hold on

minX=min(minX,x2);
maxX=max(maxX,x2);
minY=min(minY,y2);
maxY=max(maxY,y2);

x3 = h(1,3) / h(3,3);
y3 = h(2,3) / h(3,3);
plot(x3,y3,'*r');
hold on

minX=min(minX,x3);
maxX=max(maxX,x3);
minY=min(minY,y3);
maxY=max(maxY,y3);

axis([minX maxX minY maxY])
