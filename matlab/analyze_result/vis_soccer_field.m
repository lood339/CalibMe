% visualize soccer field
clear
close all;

addpath('../../data');

load('soccer_field_model.mat');
index = line_segment_index;

figure;

%daspect([max(daspect)*[1 1] 1])
N = length(index);
for i = [1: N]
    idx1 = index(i, 1) + 1;
    idx2 = index(i, 2) + 1;
    
    x = [points(idx1, 1), points(idx2, 1)];
    y = [points(idx1, 2), points(idx2, 2)];
    
    plot(x, y, 'g', 'lineWidth', 3);    
    hold on; 
end
set(gca, 'xtick', []); % Get Current Axis?
set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
set(gca, 'yticklabel', []);

axis equal
hold off;
xlim([-10, 118]);




