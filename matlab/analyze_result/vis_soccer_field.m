% visualize soccer field
clear
close all;
addpath('./matlab_util');

s = xml2struct('soccer_field_wireframe_model.xml');

t = s.opencv_storage.points.data.Text;
t = regexprep(t,'\s+',' ');  % replace \n with space, s for single?
[points, status] = str2num(t);
points = reshape(points, 2, length(points)/2)'; 
status
t = s.opencv_storage.line_index.data.Text;
t = regexprep(t, '\s+', ' ');
[index, status] = str2num(t);
index = reshape(index', 2, length(index)/2)';
status

figure;

%daspect([max(daspect)*[1 1] 1])
N = length(index);
for i = [1: N]
    idx1 = index(i, 1) + 1;
    idx2 = index(i, 2) + 1;
    
    x = [points(idx1, 1), points(idx2, 1)];
    y = [points(idx1, 2), points(idx2, 2)];
    
    plot(x, y, 'k');    
    hold on; 
end
axis equal
hold off;



