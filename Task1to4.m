clc; clear; close all;

%% Task 1: Pre-processing -----------------------
% Step-1: Load input image
imageOriginal = imread('IMG_01.jpg');
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
image_Binarization = imbinarize(img_enhance, 0.16); % Image binarisation operations
figure, imshow(image_Binarization)
title('Binary Version of Image')


%% Task 2: Edge detection ------------------------
% Detect edges in an image using the Canny edge detector
img_edge = edge(img_enhance,'canny', [0.1, 0.2], 1.4); % The parameters of the threshold matrix can be adjusted
figure, imshow(img_edge);
title('Edge Detection');


%% Task 3: Simple segmentation --------------------
% Morphologically close image
se = strel('disk', 3'); % Disc-shaped structural elements
image_close = imclose(img_edge, se);
% figure, imshow(foc), title('Close Image');

% Fill image regions and holes
image_filled = imfill(image_close, 'holes');
% figure, imshow(image_fill), title('Filled Image');

% Morphologically open image
se = strel('disk', 1'); % Disc-shaped structural elements
image_open = imopen(image_filled, se); 
figure, imshow(image_open);
title('Segmentation Image');



%% Task 4: Object Recognition --------------------

