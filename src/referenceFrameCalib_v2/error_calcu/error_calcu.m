clc
clear
load seq2_frames_ptz.mat
load seq2_ground_truth_ptz.mat

error = [];
for i = 1:size(ground_truth_ptz,2)
    gt_ptz = ground_truth_ptz(i).para;
    img_num = str2num(ground_truth_ptz(i).img_name(end-7:end-4));
    for j = 1:size(seq2_frames_ptz,2)
        if(str2num(seq2_frames_ptz(j).img_name(1:end-4)) == img_num)
            idx = j;
        end
    end
    frames_ptz = seq2_frames_ptz(idx).ptz;
    error(end+1,:) = abs(double(frames_ptz - gt_ptz));
    
end