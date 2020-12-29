
function img2 = myGrayScaleTransform (img1, para)
    a = para(1);
    b = para(2);
    if(a > b)
        error('para中参数，最小灰度值a不能超过最大灰度值b！');
    elseif(a < 0 || b > 250)
        error('para中参数，最小灰度值a和最大灰度值b的范围在区间[0,250]之间！');
    end
    img = im2double(img1);%将uint8类型的数据转换为double类型的同时，把数据范围由原来的0~255映射到0~1，可以看作数据的一种归一化,以便计算
    min_i = min(img(:));
    max_i = max(img(:));
    img2 = (img - min_i)./(max_i - min_i);%将图片压缩到0~1之间的数值
    img2 = (b - a) .* img2 + a;%还原图片像素的大小为para区间内的数值
    img2 = uint8(img2);%将图片数据转换为uint8的格式，以便输出
end