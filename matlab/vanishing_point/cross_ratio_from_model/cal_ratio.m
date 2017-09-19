function r = cal_ratio(x,y,Opt)
% calculate the cross ratio from fixed soccer field model
% x,y : manually chose
    % Opt = 1 : vertical lines
    % Opt = 0 : horizontal lines
    if Opt
        r = (x(2)-x(1)) / (x(3)-x(1));
    else
        r = (y(2)-y(1)) / (y(3)-y(1));
    end
end

    