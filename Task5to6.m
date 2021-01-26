clc; clear; close all;

%% Task 5: Robust method --------------------------
% Step-1: Load input image
imageOriginal = imread('IMG_06.jpg');
figure, imshow(imageOriginal)
title('Load Original Image');

% Step-2: Covert image to grayscale
imageGray = rgb2gray(imageOriginal);
figure, imshow(imageGray)
title('Covert Image to Grayscale');

% Step-3: Rescale image
imageResize = myImage_Resize(imageGray, 0.5, 0.5);

figure,imshow(imageResize) % Grey-scale image
title('Rescale Grey-Scale Image');

% Step-4: Produce histogram· before enhancing
img_hist = imageResize(:,:,1);
figure, imhist(img_hist);  % Plot the histogram
title('Plot Histogram by imhist')

% Step-5: Enhance image before binarisation
% Contrast Adjustment
img_enhance = imadjust(imageResize);
figure, imshow(img_enhance)
title('Enhance Image by imadjust')

% Step-6: Histogram after enhancement
img_enhanceHist = img_enhance(:,:,1);
imhist(img_enhanceHist);  % Plot the histogram
title('Histogram after Enhancement')

% Step-7: Image Binarisation
image_Binarization = imbinarize(img_enhance, 0.26); % Image binarisation operations
figure, imshow(image_Binarization)
title('Binary Version of Image')


% Step-8: Edge detection ------------------------
% Detect edges in an image using the Canny edge detector
img_edge = edge(img_enhance,'canny', [0.03, 0.17], 0.7); % The parameters of the threshold matrix can be adjusted
figure, imshow(img_edge);
title('Edge Detection');
close all;

% Step-9: Simple segmentation --------------------
% Morphologically close image
se = strel('disk', 4'); % Disc-shaped structural elements
image_close = imclose(img_edge, se);
figure, imshow(image_close), title('Close Image');

% Fill image regions and holes-
image_filled = imfill(image_close, 'holes');
figure, imshow(image_filled), title('Filled Image');

% Morphologically open image
se = strel('disk', 2'); % Disc-shaped structural elements
image_open = imopen(image_filled, se);

image_seg = image_open;
figure, imshow(image_seg);
title('Segmentation Image');


% Object Recognition --------------------
[B, L] = bwboundaries(image_seg, 'noholes'); % Trace region boundaries
for i = 1 : length(B)
    temp = L;
    temp(temp ~= i) = 0;
    temp(temp == i) = 1;
    [r, c] = find(temp == 1);   
    % 'a' is the smallest rectangle by area, if by side length use 'p'.
    [rectx, recty ,area , perimeter] = minboundrect(c, r, 'a');
%     figure,imshow(temp);
%     line(rectx(:),recty(:),'color','r');
    ratio = length_width_ratio(rectx, recty);
    if ratio < 1.5
        L(L == i) = 30;
    elseif ratio < 3
        L(L== i) = 50;
    else
        L(L== i) = 70;
    end
end
figure, imshow(label2rgb(L, @jet, 'k'));
title('Object Recognition');




%% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_07_GT.png");

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT)

