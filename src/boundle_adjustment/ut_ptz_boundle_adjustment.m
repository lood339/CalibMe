clear
close all;

mex('ptz_ba_two_image.cpp', ...    
     '-I/Users/jimmy/Code/eigen_3.2.6', ...
     '-I./cvx_gl',...
     '-I./cvx_pgl', ...
     '-I./mexcpp', ...
     '-L./build', ...
     '-lcvx_core');

% boudle adjustment from two images, demo, unfinished
camera1 = [3676.645334	 1.688016	 0.454302	 -0.371234	 113.410000	 2.220000	 6.030000];
camera2 = [3351.814614	 1.707096	 0.373127	 -0.299994	 113.410000	 2.220000	 6.030000];

addpath('./data');
load('0950.mat');
location1 = keypoint;
load('1000.mat')
location2 = keypoint;

[ptz1, ptz2] = ptz_ba_two_image(camera1, camera2, location1', location2');


