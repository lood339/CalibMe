function fl_hist(fl_data,image_width)
% calculate and plot field of view value theta
% fl_data: one column of sequence ground truth ptz value
assert(size(fl_data,2) == 1);

theta = [];
for i = 1:size(fl_data,1)
    theta(i) = 2 * atan(image_width/(2*fl_data(i,1))) * 180 / 3.14;    
end

% plot
figure;
[counts, binValues] = hist(theta, 30);
normalizedCounts = counts / sum(counts);
bar(binValues, normalizedCounts, 'barwidth', 1);
xlabel('Field of view', 'FontSize', 18);
ylabel('Probability', 'FontSize', 18);
end


