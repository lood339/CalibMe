function [camera] = ptz_to_camera(ptz, pp, cc, base_rot_vec)
%pp: principal point
%cc: common camera center, 3 x1 or 1 x 3
%base_rot_vec: common base rotation vector 3 x 1
%return: camera 9 x 1

%{
Eigen::Matrix3d R = matrixFromPanYTiltX(pan(), tilt()) * cvx_gl::rotation_3d(base_rotation_).as_matrix();
        K_ = cvx_pgl::calibration_matrix(focal_length(), pp_);
R_ = cvx_gl::rotation_3d(R);
%}
assert(length(ptz) == 3);
assert(length(pp) == 2);
assert(length(cc) == 3);
assert(length(base_rot_vec) == 3);

pan = ptz(1);
tilt = ptz(2);
fl = ptz(3);
R = PanYTiltX2matrix(pan, tilt) * rotationVectorToMatrix(base_rot_vec)';
R_vec = rotationMatrixToVector(R');
camera = zeros(1, 9);
camera(1:2) = pp(1:2);
camera(3) = fl;
camera(4:6) = R_vec(1:3);
camera(7:9) = cc(1:3);

end