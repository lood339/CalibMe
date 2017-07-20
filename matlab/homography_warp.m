function warped_image = homography_warp(h, image)
% warp an image by homography h
% warped_image: output
assert(size(h, 1) == 3 && size(h, 2) == 3);
tform = projective2d(h');
warped_image = imwarp(image, tform, 'OutputView',imref2d(size(image)), ...
    'FillValues', [0, 0, 0]);

end