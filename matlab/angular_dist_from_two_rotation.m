function angular_dist = angular_dist_from_two_rotation(src_R,dst_R)
    scale = 180.0/3.14159;
    
    r1 = rotm2eul(src_R);
    r2 = rotm2eul(dst_R);
    
    q1 = angle2quat(r1(1),r1(2),r1(3));
    q2 = angle2quat(r2(1),r2(2),r2(3));
    
    val_dot = abs(dot(q1,q2));
    
    angular_dist = 2.0 * acos(val_dot) * scale;
end
    