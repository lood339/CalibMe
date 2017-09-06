clear;
close all;

addpath('/home/ritazhu/CalibMe/src/referenceFrameCalib_v2/error_calcu');

load syn_gt_ptz.mat
load world_cup_gt_ptz.mat

fl_data1 = [];
for i=1:length(ground_truth_ptz)
    fl_data1 = [fl_data1; ground_truth_ptz(i).para(3)];
end

fl_data2 = [];
for i = 1:length(syn_ground_truth_ptz)
    fl_data2 = [fl_data2; syn_ground_truth_ptz(i)];
end

image_width = 1280;
theta1 = [];
for i = 1:size(fl_data1,1)
    theta1(i) = 2 * atan(image_width/(2*fl_data1(i,1))) * 180 / 3.14;    
end

theta2 = [];
for i = 1:size(fl_data2,1)
    theta2(i) = 2 * atan(image_width/(2*fl_data2(i,1))) * 180 / 3.14; 
end

% plot
figure;
[counts, binValues] = hist(theta1, 30);
normalizedCounts = counts / sum(counts);
h1 = histogram(theta1,binValues,'Normalization','probability');
% bar(binValues, normalizedCounts,'y', 'barwidth', 1);
hold on
[counts2, binValues2] = hist(theta2, 30);
normalizedCounts2 = counts2 / sum(counts2);
h2 = histogram(theta2,binValues2,'Normalization','probability');
% bar(binValues2, normalizedCounts2,'c', 'barwidth', 1);

xlabel('Field of view', 'FontSize', 18);
ylabel('Probability', 'FontSize', 18);
legend('Soccer highlights dataset','World cup dataset');
h1.NumBins



