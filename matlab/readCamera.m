function [image_name, camera] = readCamera(file_name)
camera = dlmread(file_name, '\t', 2, 0);
fid = fopen(file_name, 'r');
image_name = fgetl(fid);
fclose(fid);
end