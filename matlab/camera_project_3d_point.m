function [im_point] = camera_project_3d_point(camera, point_3d)
% project 3d point in world coordinate to image coordinate
% camera: 9 x 1
% point_3: n x 3
assert(length(camera) == 9);
assert(size(point_3d, 2) == 3);

% step 1, projection matrix from camera
u = camera(1);
v = camera(2);
f = camera(3);
rod = camera(4:6); % Rodrigues angle
c = camera(7:9)';

K = [f, 0, u; 0, f, v; 0, 0, 1];
R = rotationVectorToMatrix(rod)';
P = eye(3, 4);
P(:,4) = -c;
P = K * R * P;

% step 2, project 3d point to 2d point
n = length(point_3d);
im_point = zeros(n, 2);

for i = [1:n]
    p = [point_3d(i, 1), point_3d(i, 2), point_3d(i, 3), 1]';
    q = P*p;
    assert(q(3) ~=0);
    im_point(i, 1) = q(1)/q(3);
    im_point(i, 2) = q(2)/q(3);    
end


end