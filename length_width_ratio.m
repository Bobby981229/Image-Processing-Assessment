% Calculate the aspect ratio of an external rectangle
function ratio=length_width_ratio(rectx,recty)
point1 = [rectx(1), recty(1)];
point2 = [rectx(2), recty(2)];
point3 = [rectx(3), recty(3)];
length1 = sqrt(sum((point1 - point2) .^ 2));
length2 = sqrt(sum((point2 - point3) .^ 2));
if length1 >= length2
    ratio = length1 / length2;
else
    ratio = length2 / length1;
end
end
