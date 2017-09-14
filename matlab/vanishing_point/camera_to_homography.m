% camera to homography
function h = camera_to_homography(camera)
% camera format: u, v, fl, rx, ry, rz, cx, xy, cz
% (rx, ry, rz) is in rodrigues format
assert(length(camera) == 9);

% 
u = camera(1);
v = camera(2);
f = camera(3);
rod = camera(4:6); % Rodrigues angle
c = camera(7:9)';

K = [f, 0, u; 0, f, v; 0, 0, 1];
rotation = rotationVectorToMatrix(rod)'; % camera rotation to world point rotation

P = K*[rotation, -rotation*c];
h = P(:,[1,2,4]);
end