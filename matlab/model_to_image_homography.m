function [h] = model_to_image_homography(camera, model_h, model_w)
assert((model_h == 70  && model_w == 118) || (model_h == 75  && model_w == 115));

template_h = model_h * 36/3; % every pixel is 3 inch
inch2meter = 0.0254;
m1 = [ 1, 0, 0; 0, -1, template_h; 0, 0, 1]; % flip image in y direction
m2 = [ 3 * inch2meter, 0, 0;  0, 3 * inch2meter, 0; 0, 0, 1]; % scale
model2world = m2 * m1;

world2image = camera_to_homography(camera);
h = world2image * model2world;  % model to image homography

end