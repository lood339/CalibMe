function [projected_point] = pan_tilt_to_point(pp, ptz, point_pan_tilt)
% pp: principal point
% ptz: pan, tilt and zoom of the principal point
% point_pan_tilt: the pan, tilt of the point, spherical ray
% return projected_point: project point in the image
assert(length(pp) == 2);
assert(length(ptz) == 3);
assert(length(point_pan_tilt) == 2);

fl = ptz(3);
d_pan = (point_pan_tilt(1) - ptz(1)) * pi/180.0;
d_tilt = (point_pan_tilt(2) - ptz(2)) * pi/180.0;
dx = fl * tan(d_pan);
dy = fl * tan(d_tilt);
projected_point = zeros(2, 1);
projected_point(1) = pp(1) + dx;
projected_point(2) = pp(2) - dy;  % opposite of the direction
end