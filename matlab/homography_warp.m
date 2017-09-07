function warped_image = homography_warp(h, image, dst_size, background_color)
% warp an image by homography h
% dst_size: warped image size, can be different from the input image
% background_color: 1 x 3, rgb [255, 255, 255] for white color
% warped_image: output
% example: output_image = homography_warp(h12, image1, size(image1));
assert(size(h, 1) == 3 && size(h, 2) == 3);
assert(length(dst_size) == 3); % 3 channel image
assert(length(background_color) == 3); 
tform = projective2d(h');                       %dst_size
warped_image = imwarp(image, tform, 'OutputView',imref2d(dst_size), ...
    'FillValues', background_color);
end