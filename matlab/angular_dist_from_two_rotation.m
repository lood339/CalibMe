function angular_dist = angular_dist_from_two_rotation(src_R,dst_R)
    scale = 180.0/3.14159;
    
    r1 = vrrotmat2vec(src_R);
    r2 = vrrotmat2vec(dst_R);
    
    q1 = angle2quat(r1);
    q2 = angle2quat(r2);
    
    val_dot = abs(dot(q1,q2));
    
    angular_dist = 2.0 * acos(val_dot) * scale;
end
    