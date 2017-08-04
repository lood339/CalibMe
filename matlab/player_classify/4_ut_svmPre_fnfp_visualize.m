clc
clear all
close all

addpath('.\utils')

% test data & svm_model
load SIFT_feat_test
load c1

%load annotation
load('annotation_1.mat');

%Set test data root
DataRoot='./seq2/';

BBoxSize=size(bbx_feat_test,1);
OtherSize=size(other_feat_test,1);
test_data=[bbx_feat_test;other_feat_test];

% ground truth
label=[ones(BBoxSize,1)*-1;ones(OtherSize,1)];

% use svm_model to predict
pre_label = svm_pre(c1,test_data(:,1:128));
acc=length(find((label-pre_label)==0))/numel(label)

% total confusion matrix
cm = confusionmat(label,pre_label);
cm_normalize = cm/sum(cm(:));

% compute FN & FP
false_neg = fn(label,pre_label,test_data(:,129:end));
false_pos = fp(label,pre_label,test_data(:,129:end));

%visualization
visualization_cls(test_data(:,end-2:end),false_neg,false_pos,annot,DataRoot,0.5);