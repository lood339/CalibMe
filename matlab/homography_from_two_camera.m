clear
close all

addpath('./test_image');

load('camera_3600.mat');
camera2 = camera;
image2 = imread('00003600.jpg');

load('camera_14400.mat');
camera1 = camera;
image1 = imread('00014400.jpg');

h1 = camera_to_homography(camera1);
h2 = camera_to_homography(camera2);

h12 = h2 * inv(h1);  % homography from image 1 to image 2


% test estimated homography by random points
[h, w, c] = size(image1);

image3= cat(2, image1, image2); %horizonal concat image 1 and image 2
imshow(image3);
hold on;
for i = [1:20]
    x = randi(w, 1);
    y = randi(h, 1);
    p = h12*[x,y,1]';  % project from image 1 to image 2
    px = p(1)/p(3);
    py = p(2)/p(3);
    
    if px >= 0 && px <= w && py >= 0 && py < h
        xx = [x, px+w];
        yy = [y, py];
        plot(xx', yy', '-*');        
    end   
end








