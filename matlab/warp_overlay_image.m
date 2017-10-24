function [overlay_image] = warp_overlay_image(h, image1, image2)
% warp image1 to image2 by homography h
assert(size(h, 1) == 3 && size(h, 2) == 3);
assert(length(size(image1)) == 3);
assert(length(size(image2)) == 3);

dst_size = size(image2);

% warp image
tform = projective2d(h');                       %dst_size
warped_image = imwarp(image1, tform, 'OutputView',imref2d(dst_size), 'FillValues', [0, 0, 0]);

% warp a blank template
height = size(image1, 1);
width = size(image1, 2);
channel = size(image1, 3);
template = uint8(ones(height, width, channel))*255;
warped_template = homography_warp(h, template, size(image2), [0, 0, 0]);


overlay_image = warped_image + image2.*(1-warped_template);

end