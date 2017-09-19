clear
close all

addpath('/home/ritazhu/sports/vanishing_point');

load('worldcup_2014_model.mat');
load('ratio_horizontal_line.mat');

% draw projected model on the image
figure; 
model_line_segment = line_segment_index + 1;
idx1 = model_line_segment(:, 1); % linesegment start index
idx2 = model_line_segment(:, 2); % linesegment end index
x = [points(idx1, 1), points(idx2, 1)];
y = [points(idx1, 2), points(idx2, 2)];
plot(x', y', 'b', 'lineWidth', 2);
hold on

[x,y] = ginput(3);
r = cal_ratio(x,y,0);

% specify three lines' numbers to calculate ratio
ratio_horizontal_line(end+1,1) = 156;

ratio_horizontal_line(end,2) = r;

save('ratio_horizontal_line','ratio_horizontal_line');
    
    