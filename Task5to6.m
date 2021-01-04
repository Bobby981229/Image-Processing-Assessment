% Task 5: Robust method --------------------------

clc; clear; close all;

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


%% Task 2: Edge detection ------------------------
% Detect edges in an image using the Canny edge detector
img_edge = edge(img_enhance,'canny', [0.03, 0.17], 0.7); % The parameters of the threshold matrix can be adjusted
figure, imshow(img_edge);
title('Edge Detection');

% img_edge2 = edge(img_enhance,'canny', [0.03, 0.17], 0.7); % The parameters of the threshold matrix can be adjusted
% figure, imshow(img_edge2);
% title('Edge Detection2');



%% Task 3: Simple segmentation --------------------
% Morphologically close image
se = strel('disk', 6'); % Disc-shaped structural elements
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

figure, imshow(image_open)
title('Circular Recognition');
hold on
[centersBright,radiiBright,metricBright] = imfindcircles(image_open, [20 25], ...
    'ObjectPolarity', 'bright', 'Sensitivity', 0.95, 'EdgeThreshold', 0.1);
[centers,radii] = imfindcircles(image_open, [20 25], 'ObjectPolarity', 'dark');
hBright = viscircles(centersBright, radiiBright, 'Color', [0.8500 0.3250 0.0980]);
h = viscircles(centers, radii);
hold off


L = bwlabel(image_seg);
s = regionprops(L, 'Centroid');
figure, imshow(image_seg)
title('Label the Objects');
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    text(c(1), c(2), sprintf('%d', k), 'HorizontalAlignment', 'center','VerticalAlignment', 'middle');
end
hold off


[B, L] = bwboundaries(image_seg, 'noholes');
circular_Matrix = [7 9 11 13];  % Set a martix to display the circular element
shortScrews_Matrix = [1 2 5 8 10 12 14];  % Set a martix to display the short screws element
longScrews_Matrix = [3 4 6 15];  % Set a martix to display the long screws element


L(ismember(L, circular_Matrix)) = 5;
L(ismember(L, shortScrews_Matrix)) = 7;
L(ismember(L, longScrews_Matrix)) = 5;

figure, imshow(label2rgb(L, @jet, 'k'));
title('Object Recognition');



%% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT)
