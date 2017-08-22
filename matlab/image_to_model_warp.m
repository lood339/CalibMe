function [h, warped_im] = image_to_model_warp(camera, image, ...
    model_points, model_line_segment)
% warp an image to the mode image
model_h = 70; % yard
model_w = 118;
template_h = model_h * 36/3; % every pixel is 3 inch
inch2meter = 0.0254;
m1 = [ 1, 0, 0; 0, -1, template_h; 0, 0, 1]; % flip image in y direction
m2 = [ 3 * inch2meter, 0, 0;  0, 3 * inch2meter, 0; 0, 0, 1]; % scale
model2world = m2 * m1;

world2image = camera_to_homography(camera);
h = world2image * model2world;  % model to image homography
h = inv(h);   % image to model homography

template = uint8(ones(model_h*12, model_w*12, 3))*255;
% warp image to model (pixel) coordiante
warped_im = homography_warp(h, image, size(template), [255, 255, 255]);

% pad imag with 10 pixel
pad = 10;
pad_im = uint8(ones(size(warped_im, 1)+pad*2, size(warped_im,2)+pad*2, 3)) * 255;
pad_im(pad:size(warped_im, 1)+pad-1,pad:size(warped_im, 2)+pad-1, :) = warped_im;

world2model = inv(model2world);  % world (meter) to model (pixel)

N = size(model_points, 1);
image_points = zeros(N, 2);

for i = [1:N]
    p = [model_points(i, 1), model_points(i, 2), 1.0]';    
    p = world2model*p;
    x = p(1)/p(3);
    y = p(2)/p(3);  % p(3) may be zero
    image_points(i, :) = [x+pad, y+pad];
end

% draw projected model on the image
figure(1); imshow(pad_im);
hold on;
idx1 = model_line_segment(:, 1); % linesegment start index
idx2 = model_line_segment(:, 2); % linesegment end index
x = [image_points(idx1, 1), image_points(idx2, 1)];
y = [image_points(idx1, 2), image_points(idx2, 2)];
plot(x', y', 'g', 'lineWidth', 2);

end