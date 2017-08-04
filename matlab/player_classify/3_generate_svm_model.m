% generate svm model --c1
clc
clear all
close all

addpath('.\utils')

load SIFT_feat_train

data = [bbx_feat_train;other_feat_train];
theclass = ones(size(data,1),1);
theclass(1:size(bbx_feat_train,1)) = -1;

% train SVM classifier
c1 = fitcsvm(data,theclass,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[-1,1]);

save('c1','c1');

