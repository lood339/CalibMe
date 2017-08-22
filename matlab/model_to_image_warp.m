% model to image warp
function [h, warped_template] = model_to_image_warp(camera, dst_size)
% soccer field is 118 x 70 yard
% camera: u, v, fl, rx, ry, rz, cx, xy, cz
% dst_size: destination image size. [h, w, 3]
% return value: h, the model to image homography
%               warped_template: warped template by camera projection
%               [h, w, 3], [225, 225, 225] --> overlapped by model
% In the code, model: world coordinate
% template: an image tha represent the model
% image: an real image

model_h = 70; % yard
model_w = 118;
template_h = model_h * 36/3; % every pixel is 3 inch
inch2meter = 0.0254;
m1 = [ 1, 0, 0; 0, -1, template_h; 0, 0, 1]; % flip image in y direction
m2 = [ 3 * inch2meter, 0, 0;  0, 3 * inch2meter, 0; 0, 0, 1]; % scale
model2world = m2 * m1;

world2image = camera_to_homography(camera);
h = world2image * model2world;  % model to image homography

% model template is an image
template = uint8(ones(model_h*12, model_w*12, 3))*255;

warped_template = homography_warp(h, template, dst_size);
               
end
