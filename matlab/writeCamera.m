function writeCamera(file_name, image_name, camera)
% file_name: .txt file
% image_name: .jpg file
% camera: 9 x 1 or 1 x 9 
assert(length(camera) == 9);
f = fopen(file_name, 'w');
fprintf(f, '%s\n', image_name);
fprintf(f, 'ppx	 ppy	 focal length	 Rx	 Ry	 Rz	 Cx	 Cy	 Cz\n');
fprintf(f, '%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n', camera(1), camera(2), camera(3),...
    camera(4), camera(5), camera(6), camera(7), camera(8), camera(9));
fclose(f);
end