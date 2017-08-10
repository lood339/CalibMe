clc
clear

ground_truth_ptz = {};

for i = 950:5:995
    [image_name, camera] = readCamera(strcat('/home/ritazhu/sports/CalibMe-master/matlab/soccer_1_seq2_annotation/0',num2str(i),'_manual_calib.txt'));
    cc = camera(end-2:end);
    base_rotation = camera(4:6);
    camera1 = camera(3:end);
    ground_truth_ptz(end+1).img_name = image_name;
    ground_truth_ptz(end).para = camera2PTZ(cc, base_rotation, camera1);
end

for i = 1000:5:1065
    [image_name, camera] = readCamera(strcat('/home/ritazhu/sports/CalibMe-master/matlab/soccer_1_seq2_annotation/',num2str(i),'_manual_calib.txt'));
    cc = camera(end-2:end);
    base_rotation = camera(4:6);
    camera1 = camera(3:end);
    ground_truth_ptz(end+1).img_name = image_name;
    ground_truth_ptz(end).para = camera2PTZ(cc, base_rotation, camera1);
end
save('seq2_ground_truth_ptz','ground_truth_ptz');