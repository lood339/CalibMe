function h12 = homography_from_two_camera(camera_txt1,camera_txt2,rgb_image1,rgb_image2)
% camera_txt1,camera_txt2:filename,txt format
% test code:
% rgb_image1 = imread('00003600.jpg');
% rgb_image2 = imread('00014400.jpg');
% h12 = homography_from_two_camera('00003600.txt','00014400.txt',rgb_image1,rgb_image2);

assert(size(camera_txt1,2) == 12);
assert(size(camera_txt2,2) == 12);
assert(size(rgb_image1,3) == 3);
assert(size(rgb_image2,3) == 3);

c1 = readtable(camera_txt1);
camera1 = table2array(c1);

c2 = readtable(camera_txt2);
camera2 = table2array(c2);

% invoke function camera_to_homography to get matrix
h1 = camera_to_homography(camera1);
h2 = camera_to_homography(camera2);

h12 = h2 * inv(h1);% homography from image1 to image2

% test estimated homography by random points
[h,w] = size(rgb_image1);

image3 = cat(2,rgb_image1,rgb_image2); % horizonal concat image 1 and image 2
imshow(image3);
hold on

for i = 1:20
    x = randi(w,1);
    y = randi(h,1);
    p = h12 * [x,y,1]';% project from image 1 to image 2
    px = p(1) / p(3);
    py = p(2) / p(3);
    
    if(px >= 0 && px <= w && py >= 0 && py <= h)
        xx = [x,px + w];
        yy = [y,py];
        plot(xx',yy','-*');
    end
end






    




