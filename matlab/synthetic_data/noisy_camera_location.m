% 

clear
close all

addpath('/Users/jimmy/Source/CalibMe/matlab');
addpath('/Users/jimmy/Source/CalibMe/data');

load('stadium_points_dense.mat');
stadium_points = all_points;

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

base_rot = rotationVectorToMatrix(rod)';
base_rot_axis = rotm2axang(base_rot);
base_rot_axis = base_rot_axis(1:3);

cc_noise_level = [0:0.1:0.5];
n_cc = length(cc_noise_level);
angular_mean_std = zeros(n_cc, 2);
fl_mean_std = zeros(n_cc, 2);
for i = [1:n_cc]
    N = 200;
    angular_error = zeros(N, 1);
    fl_error = zeros(N, 1);
    valid_index = 1;
    for j = [1:N]
        pan = pan_min + (pan_max - pan_min)*rand(1, 1);
        tilt = tilt_min + (tilt_max - tilt_min)*rand(1, 1);
        fl = fl_min + (fl_max - fl_min)*rand(1, 1);
        ptz = [pan, tilt, fl];
        
        camera = ptz_to_camera(ptz, pp, cc, rod);

        % add noise to camera center
        noisy_cc = cc + normrnd(0, cc_noise_level(i), [1, 3]);
        noisy_camera = ptz_to_camera(ptz, pp, noisy_cc, rod);

        % project model using noisy camera
        noisy_im_point = camera_project_3d_point(noisy_camera, stadium_points);
        im_point = camera_project_3d_point(camera, stadium_points);

        % filter points outsider of the image space
        in_image_mask = noisy_im_point(:,1) >= 0 & noisy_im_point(:,1) < im_size(1) ...
                       & noisy_im_point(:,2) >= 0 & noisy_im_point(:,2) < im_size(2); 

        noisy_im_point = noisy_im_point(in_image_mask ~= 0, :);
        im_point = im_point(in_image_mask ~= 0, :); 
        n = length(im_point);
        if n < 20
            continue;
        end

        % point to pan, tilt from ground truth ptz    
        pan_tilts = zeros(n, 2);
        for k = [1:n]
            pan_tilts(k,:) = point_to_pan_tilt(pp, ptz, im_point(k,:));
        end

        % add noise to pixel location
        noisy_im_point = noisy_im_point + normrnd(0, 0.5, [n, 2]);

        % estimate image pan, tilt from observations
        estimated_ptz = ptz_ransac(noisy_im_point, pan_tilts, 2.0);

        angular_error(valid_index) = angular_dist_from_two_rotation(PanYTiltX2matrix(ptz(1), ptz(2)), ...
                PanYTiltX2matrix(estimated_ptz(1), estimated_ptz(2)));
        fl_error(valid_index) = estimated_ptz(3) - ptz(3);

        valid_index = valid_index + 1;
    end
    angular_error = angular_error([1:valid_index-1]);
    fl_error = abs(fl_error([1:valid_index-1]));
    
    angular_mean_std(i, 1) = mean(angular_error);
    angular_mean_std(i, 2) = std(angular_error);
    fl_mean_std(i, 1) = mean(fl_error);
    fl_mean_std(i, 2) = std(fl_error);
end



%gt_ptz = gt_ptz([1:valid_index-1], :);
%est_ptz = est_ptz([1:valid_index-1], :);







