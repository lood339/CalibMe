function Xpnts = compute_intersection_points(lines)

% Computing intersections of all the lines
p1 = [lines(:, [1 3]) ones(size(lines, 1), 1)];
p2 = [lines(:, [2 4]) ones(size(lines, 1), 1)];
% get plane normals for line segments
l = cross(p1, p2);
l = l ./ repmat(sqrt(sum(l.^2,2)), 1, 3);

[XX YY]=meshgrid(1:size(l,1));
ll1=l(XX(:),:);ll2=l(YY(:),:);
Xpnts=cross(ll1,ll2);

%[x1 y1 x2 y2 x3 y3] are colinear if x1(y2-y3)+x2(y3-y1)+x3(y1-y2)=0;
colchck=[lines(XX(:),1) lines(XX(:),3) lines(YY(:),1) lines(YY(:),3) lines(YY(:),2) lines(YY(:),4)];
colchck=colchck(:,1).*(colchck(:,4)-colchck(:,6))+colchck(:,3).*(colchck(:,6)-colchck(:,2))+...
    colchck(:,5).*(colchck(:,2)-colchck(:,4));

keepind=find(abs(colchck)>50);
Xpnts=Xpnts(keepind,:);
Xpnts=[Xpnts(:,1)./Xpnts(:,3) Xpnts(:,2)./Xpnts(:,3)];
