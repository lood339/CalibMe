clc
clear
load seq2_frames_ptz.mat
load seq2_ground_truth_ptz.mat

% 0950_manual_calib ptz calcu
[ptz] = camera2PTZ([113.410000,2.220000,6.030000],[1.278234, 1.118293, -1.103959] ,[3678.489386,1.687071,0.453461,-0.370934,113.410000,2.220000,6.030000] )


gt_ptz = ground_truth_ptz(1).para;
frames_ptz = seq2_frames_ptz(6).ptz;
error = gt_ptz-frames_ptz;