function VoteArr = compute_linePt_vote(lines,Xpnts)
ta=pi/3;
% lines=[lines sqrt(((lines(:,1)-lines(:,2)).^2+(lines(:,3)-lines(:,4)).^2))];
maxl=max(lines(:,7));

VoteArr=zeros(size(lines,1),size(Xpnts,1));
for i1=1:size(lines,1)
    [theta,vpinfchk]=line_Vp_dist(lines(i1,:),Xpnts);
    theta=theta.*(pi/180);
    
    indd=find(theta < ta & vpinfchk ==1);
    VoteArr(i1,indd)= (1-(1/ta).*theta(indd));
%     VoteArr(i1,indd)= w1*(1-(1/ta).*theta(indd))+ w2*lines(i1,7)/maxl;
end
VoteArr = exp(-(1-VoteArr).^2/0.1/0.1/2);
VoteArr = repmat(lines(:,7),1,size(VoteArr,2)).*VoteArr/maxl;
return;
