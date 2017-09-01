function project_back_project_model(gt_camera, predicted_camera, ...
                model_size, ...
                model_points, model_linesegment)
% gt_camera,predicted_camera: u, v, fl, rx, ry, rz, cx, xy, cz
% model_size: 2 x 1, model height and width in Yard
% model_point: points in the model
% model_linesegment: line segment index in the model
assert(length(gt_camera) == 9);
assert(length(predicted_camera) == 9);
assert(length(model_size) == 2);

model_h = model_size(1);
model_w = model_size(2);
gt_h  = camera_to_homography(gt_camera);
est_h = camera_to_homography(predicted_camera);

% homography composition
h = inv(est_h) * gt_h;

N = length(model_points);
transformed_points = zeros(N, 2);
for i = [1:N]
    p = [model_points(i, 1), model_points(i, 2), 1.0]';
    % translate, rotate, then project
    p = h * p;
    assert(p(3) ~= 0);
    x = p(1)/p(3);
    y = p(2)/p(3);  % p(3) may be zero
    transformed_points(i, :) = [x, y];    
end

% draw projected model on the image
figure; 

idx1 = model_linesegment(:, 1); % linesegment start index
idx2 = model_linesegment(:, 2); % linesegment end index
x = [model_points(idx1, 1), model_points(idx2, 1)];
y = [model_points(idx1, 2), model_points(idx2, 2)];
plot(x', y', 'b', 'lineWidth', 2);
hold on;
x = [transformed_points(idx1, 1), transformed_points(idx2, 1)];
y = [transformed_points(idx1, 2), transformed_points(idx2, 2)];
plot(x', y', 'r-', 'lineWidth', 2);

axis equal
set(gca,'xtick',[])
set(gca,'ytick',[])


end