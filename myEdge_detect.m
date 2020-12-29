function [] = myEdge_detect(image_name)

grayPic = mat2gray(image_name);
[m, n] = size(grayPic);
newGrayPic = grayPic;
sobelNum = 0;
sobelThreshold = 0.8;

for i = 2 : m-1 
    for j=2 : n - 1   
        sobelNum = abs(grayPic(i - 1, j + 1) + 2 * grayPic(i, j + 1) + grayPic(i + 1,j + 1) - grayPic(i - 1, j - 1) - 2 * grayPic(i, j - 1) - grayPic(i + 1, j - 1)) +...
        abs(grayPic(i - 1,j - 1) + 2 * grayPic(i - 1, j) + grayPic(i - 1, j + 1) - grayPic(i + 1, j - 1) - 2 * grayPic(i + 1, j) - grayPic(i + 1, j + 1));    
    
        if (sobelNum > sobelThreshold)
            newGrayPic(i, j) = 255;   
        else
            newGrayPic(i, j) = 0; 
        end    
    end 
end

figure,imshow(newGrayPic);
title('Sobel Result')