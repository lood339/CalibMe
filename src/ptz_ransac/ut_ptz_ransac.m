clear
close all;

%{
mex('ptz_ransac.cpp', ...    
     '-I/Users/jimmy/Code/eigen_3.2.6', ...
     '-I./cvx_gl',...
     '-I./cvx_pgl', ...
     '-I./util', ...
     '-I./mexcpp', ...
     '-L./build', ...
     '-lcvx_core');
%}

% boudle adjustment from two images, demo, unfinished

load('data.mat');
points = sampled_points;
[ptz] = ptz_ransac(points, pan_tilts, 2);


