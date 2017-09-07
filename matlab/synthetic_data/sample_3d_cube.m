function [points] = sample_3d_cube(x_min, x_max, y_min, y_max, z_min, z_max, n)
assert(x_min <= x_max);
assert(y_min <= y_max);
assert(z_min <= z_max);
points = zeros(n, 3);
points(:,1) = x_min + (x_max - x_min)*rand(n, 1);
points(:,2) = y_min + (y_max - y_min)*rand(n, 1);
points(:,3) = z_min + (z_max - z_min)*rand(n, 1);
end

