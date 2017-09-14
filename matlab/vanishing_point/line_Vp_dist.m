function   [theta vpinfchk]=line_Vp_dist(linel,vp)
%line segment s 
x1=linel(1); x2=linel(2);y1=linel(3);y2=linel(4);
midpntl=[(x1+x2)/2  (y1+y2)/2];
lengthl=sqrt((x1-x2)^2+(y1-y2)^2);

slope1=(y2-y1)/(x2-x1);

%line segment s_dash
slope2=(vp(:,2)-ones(size(vp,1),1)*midpntl(2))./(vp(:,1)-ones(size(vp,1),1)*midpntl(1));
% slope2=(vp(1)-midpntl(1))/(vp(2)-midpntl(2));

%angle between s and s_dash
theta=atand(abs((ones(size(slope2,1),1)*slope1-slope2(:))./(1+ones(size(slope2,1),1)*slope1.*slope2(:))));

%midpoint and slope of s and s_dash are same 
%check if vp lies on rotated s_dash 
d=sqrt((vp(:,1)-ones(size(vp,1),1)*midpntl(1)).^2+(vp(:,2)-ones(size(vp,1),1)*midpntl(2)).^2);
vpinfchk=zeros(size(vp,1),1);
vpinfchk(d > lengthl/2)=1;
return