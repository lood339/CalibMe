% 

clear
close all

addpath('/Users/jimmy/Source/CalibMe/matlab');
addpath('/Users/jimmy/Source/CalibMe/data');

cc = [114.323180, 1.114215, 6.375646];
rod = [1.230319, 1.129962, -1.157628];
pan_min = 15;
pan_max = 70;
tilt_min = -14;
tilt_max = -5;
fl_min = 1500;
fl_max = 5000;
pp = [1280/2, 720/2];
im_size = [720, 1280, 3];


pixel_noise_level_all = [0.5:0.5:3];
threshold = 100; % use all observation
m = length(pixel_noise_level_all);
angular_mean_std = zeros(m, 2);
fl_mean_std = zeros(m, 2);
for i = [1:length(pixel_noise_level_all)]
    n = 200;
    ratio = 0.9;
    pixel_noise_level = pixel_noise_level_all(i);

    N = 50;
    gt_ptz = zeros(N, 3);
    est_ptz = zeros(N, 3);
    angular_error = zeros(N, 3);
    valid_index = 1;
    for j = [1:N]
        pan = pan_min + (pan_max - pan_min)*rand(1, 1);
        tilt = tilt_min + (tilt_max - tilt_min)*rand(1, 1);
        fl = fl_min + (fl_max - fl_min)*rand(1, 1);
        ptz = [pan, tilt, fl];
        
        camera = ptz_to_camera(ptz, pp, cc, rod);        
        % synthetic image
        [h, im] = model_to_image_warp(camera, im_size);
        %figure(1); clf;
        %imshow(im);
        %pause(2);
        [valid, sampled_points] = sample_point_in_image(im(:,:,1), n, ratio);    
        if valid == 0
            continue;
        end

        % point to pan, tilt    
        pan_tilts = zeros(n, 2);
        for k = [1:n]
            pan_tilts(k,:) = point_to_pan_tilt(pp, ptz, sampled_points(k,:));
        end

        % add noise to pixel location
        sampled_points = sampled_points + normrnd(0, pixel_noise_level, [n, 2]);

        % estimate image pan, tilt from observations
        estimated_ptz = ptz_ransac(sampled_points, pan_tilts, threshold);

        % measure error
        err = estimated_ptz - ptz';

        gt_ptz(valid_index, :) = ptz;
        est_ptz(valid_index, :) = estimated_ptz';
        angular_error(valid_index) = angular_dist_from_two_rotation(PanYTiltX2matrix(ptz(1), ptz(2)), ...
            PanYTiltX2matrix(estimated_ptz(1), estimated_ptz(2)));
        valid_index = valid_index + 1;
    end
    gt_ptz = gt_ptz([1:valid_index-1], :);
    est_ptz = est_ptz([1:valid_index-1], :);
    angular_error = angular_error([1:valid_index-1]);
    
    angular_mean_std(i, 1) = mean(angular_error);
    angular_mean_std(i, 2) = std(angular_error);
    
    fl_dif = abs(gt_ptz(:,3) - est_ptz(:,3));
    fl_mean_std(i, 1) = mean(fl_dif);
    fl_mean_std(i, 2) = std(fl_dif);        
    
end






