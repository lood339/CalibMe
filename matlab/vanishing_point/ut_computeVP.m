clear
close all
addpath('/home/ritazhu/sports/vanishing_point');

im = imread('17.jpg');
[vp,~,~] = computeVP(im,1);

% figure;
% imshow(im);
% hold on
minX=inf;
maxX=-inf;
minY=inf;
maxY=-inf;

plot(vp(1),vp(2),'r*');hold on;
minX=min(minX,vp(1));
maxX=max(maxX,vp(1));
minY=min(minY,vp(2));
maxY=max(maxY,vp(2));
plot(vp(3),vp(4),'g*');hold on;
minX=min(minX,vp(3));
maxX=max(maxX,vp(3));
minY=min(minY,vp(4));
maxY=max(maxY,vp(4));
plot(vp(5),vp(6),'b*');hold on;
minX=min(minX,vp(5));
maxX=max(maxX,vp(5));
minY=min(minY,vp(6));
maxY=max(maxY,vp(6));

axis([minX maxX minY maxY])