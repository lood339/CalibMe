function [pan_tilt] = point_to_pan_tilt(pp, ptz, point)
% pp: principal point 2 x 1
% ptz: pan, tilt, zoom, 3 x 1
% point: image pixel location 2 x 1 , from (0, 0)
% return: pan_tilt of the point
assert(length(pp) == 2);
assert(length(ptz) == 3);
assert(length(point) == 2);
dx_dy = point - pp;
fl = ptz(3);
delta_pan = atan2(dx_dy(1), fl) * 180.0/pi; % opposite is y direction ??
delta_tilt = atan2(dx_dy(2), fl) * 180.0/pi;
pan_tilt = zeros(2, 1);
pan_tilt(1) = ptz(1) + delta_pan;
pan_tilt(2) = ptz(2) - delta_tilt;
end