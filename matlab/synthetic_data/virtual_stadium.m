clear
close all

addpath('/Users/jimmy/Source/CalibMe/data/');

load('worldcup_2014_model.mat');
line_segment_index = line_segment_index + 1;

figure;
idx1 = line_segment_index(:, 1); % linesegment start index
idx2 = line_segment_index(:, 2); % linesegment end index
x = [points(idx1, 1), points(idx2, 1)];
y = [points(idx1, 2), points(idx2, 2)];
z = zeros(length(x), 2);
plot3(x', y', z', 'g', 'lineWidth', 2); hold on;


x_min = 0;
x_max = 115 * 0.9144;
y_min = 0;
y_max = 74 * 0.9144;

side_width = 5;
sample_num = 200;
[playing_field] = sample_3d_cube(x_min, x_max, y_min, y_max, 0, 0, sample_num/2);
[left_side] = sample_3d_cube(x_min - side_width, x_min, y_min - side_width, y_max + side_width, 0, 20, sample_num);
[right_side] = sample_3d_cube(x_max, x_max + side_width, y_min - side_width, y_max + side_width, 0, 20, sample_num);
[top_side] = sample_3d_cube(x_min - side_width, x_max + side_width, y_max, y_max + side_width, 0, 20, sample_num);
%[bottom_side] = sample_3d_cube(x_min - side_width, x_max + side_width, y_min - side_width, y_min, 0, 20, 200);

pts = playing_field;
plot3(pts(:,1), pts(:,2), pts(:, 3), 'b.'); hold on;
pts = left_side;
plot3(pts(:,1), pts(:,2), pts(:, 3), 'b.');
pts = right_side;
plot3(pts(:,1), pts(:,2), pts(:, 3), 'b.');
pts = top_side;
plot3(pts(:,1), pts(:,2), pts(:, 3), 'b.');
%pts = bottom_side;
%plot3(pts(:,1), pts(:,2), pts(:, 3), 'b.');

axis equal
set(gca, 'FontSize', 16);

% save points
all_points = [playing_field; left_side; right_side; top_side];

