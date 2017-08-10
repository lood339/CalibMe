clc
clear
load camera_frames_sort_seq2.mat
seq2_frames_ptz = {};
for i = 1:size(camera_frames_sort,2)
    cc = camera_frames_sort(i).para(end-2:end);
    base_rotation = [1.278234, 1.118293, -1.103959];
    camera = camera_frames_sort(i).para(3:end);
    seq2_frames_ptz(end+1).img_name = camera_frames_sort(i).img_name;
    seq2_frames_ptz(end).camera = camera;
    seq2_frames_ptz(end).ptz = camera2PTZ(cc, base_rotation, camera);
end
save('seq2_frames_ptz','seq2_frames_ptz');
