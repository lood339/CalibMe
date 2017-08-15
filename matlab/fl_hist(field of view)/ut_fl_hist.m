clear;
close all;

load('/home/ritazhu/CalibMe/src/referenceFrameCalib_v2/error_calcu/soccer2_seq4_ground_truth_ptz.mat');

fl_data = [];
for i=1:length(ground_truth_ptz)
    fl_data = [fl_data; ground_truth_ptz(i).para(3)];
end

fl_hist(fl_data,1280);