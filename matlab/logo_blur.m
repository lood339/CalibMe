function blurred_channel = logo_blur(channel,c,r)
    BW = roipoly(channel,c,r);
    h = fspecial('average',25);
    blurred_channel = roifilt2(h,channel,BW);
end
