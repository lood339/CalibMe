function [image] = project_model_by_homography(homography, model_points, model_line_segment, rgb_image)
% project a 2D field model to the image space
% homography: 3 x 3, from model to image
% model_points: N x 2 matrix, model world coordinate in meter
% model_line_segment: line segment index, start from 1
% rgb_image: an RGB image
% example: 
assert(size(homography, 1) == 3 && size(homography, 2) == 3);
assert(size(model_points, 2) == 2);
assert(size(model_line_segment, 2) == 2);
assert(size(rgb_image, 3) == 3);

N = size(model_points, 1);
image_points = zeros(N, 2);

for i = [1:N]
    p = [model_points(i, 1), model_points(i, 2), 1.0]';    
    p = homography*p;
    x = p(1)/p(3);
    y = p(2)/p(3);  % p(3) may be zero
    image_points(i, :) = [x, y];    
end

% draw projected model on the image
figure(1); imshow(rgb_image);
hold on;
idx1 = model_line_segment(:, 1); % linesegment start index
idx2 = model_line_segment(:, 2); % linesegment end index
x = [image_points(idx1, 1), image_points(idx2, 1)];
y = [image_points(idx1, 2), image_points(idx2, 2)];
plot(x', y', 'g', 'lineWidth', 2);

f = getframe(gcf)
image =f.cdata;
close(1)
end