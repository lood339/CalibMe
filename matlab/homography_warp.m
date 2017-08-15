function warped_image = homography_warp(h, image, dst_size)
% warp an image by homography h
% dst_size: warped image size, can be different from the input image
% warped_image: output
% example: output_image = homography_warp(h12, image1, size(image1));
assert(size(h, 1) == 3 && size(h, 2) == 3);
assert(length(dst_size) == 3); % 3 channel image
tform = projective2d(h');                       %dst_size
warped_image = imwarp(image, tform, 'OutputView',imref2d(dst_size), ...
    'FillValues', [0, 0, 0]);

end