function [vp Pout]=ordervp(vp,h,w,Pin)
%Note this takes VP=[x1 y1; x2 y2; x3 y3 ]as input
%if P is given P is also shuffled 
if nargin < 4
Pin=[];
Pout=[];
end

vptemp=vp;
dists = ((vp(:,1)-w/2).^2 + (vp(:,2)-h/2).^2).^0.5;
[vv,ii] = sort(dists,'descend');
vp = vp(ii,:);
dot1 = dot(vp(1,:)-[w/2,h/2],[1 0])/norm(vp(1,:)-[w/2,h/2]);
dot2 = dot(vp(2,:)-[w/2,h/2],[1 0])/norm(vp(2,:)-[w/2,h/2]);
if abs(dot1)>abs(dot2)
    tempvar = vp(1,:);
    vp(1,:) = vp(2,:);
    vp(2,:) = tempvar;
end


        
    
if numel(Pin)>0

ind=find(vptemp(:,1)==vp(1,1) & vptemp(:,2)==vp(1,2));
Pout=Pin(:,ind);
ind=find(vptemp(:,1)==vp(2,1) & vptemp(:,2)==vp(2,2));
Pout=[Pout Pin(:,ind)];
ind=find(vptemp(:,1)==vp(3,1) & vptemp(:,2)==vp(3,2));
Pout=[Pout Pin(:,ind)];
Pout=[Pout Pin(:,4)];% 4th is outlier
end

 return
