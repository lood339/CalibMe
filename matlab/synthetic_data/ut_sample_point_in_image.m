clear
close all

image = imread('temp.png');
n = 1000;
r = 0.9;
[points] = sample_point_in_image(image(:, :, 1), n, r);


figure;
plot(points(:,1), points(:,2), '.');
set(gca, 'YDir', 'reverse');