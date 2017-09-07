function [valid, points] = sample_point_in_image(image, n, r)
% image: a white black image h x w
% n: total number of points
% r: ratio of points on black area (background)
% return: points, index from (0, 0)
assert(length(size(image)) == 2);
assert(r >= 0 && r <= 1);

points = zeros(n, 2);

% foreground pixels
[row, col] = find(image);
if length(row) == 0
    valid = 0;
    return;
end
n_f = int32(n * (1-r));
n_b = n - n_f;
index = randi(length(row), n_f, 1);
points(1:n_f, 1) = col(index) - 1;
points(1:n_f, 2) = row(index) - 1;

% background pixel
[row, col] = find(image == 0);
if length(row) == 0
    valid = 0;
    return;
end
index = randi(length(row), n_b, 1);
points(n_f+1:n, 1) = col(index) - 1;
points(n_f+1:n, 2) = row(index) - 1;

% randomly shuffle background and foregournd pixel locations
index = randperm(n);
points = points(index, :);
valid = 1;

end