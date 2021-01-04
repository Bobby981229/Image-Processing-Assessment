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
% figure, imshow(image_close), title('Close Image');

% Fill image regions and holes-
image_filled = imfill(image_close, 'holes');
% figure, imshow(image_filled), title('Filled Image');

% Morphologically open image
se = strel('disk', 1'); % Disc-shaped structural elements
image_open = imopen(image_filled, se);

image_seg = image_open;
figure, imshow(image_seg);
title('Segmentation Image');


%% Task 4: Object Recognition --------------------

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
circular_Matrix = [2 4 6 8 9 10];  % Set a martix to display the circular element
nonCircula_Matrix = [1 3 5 7 11];  % Set a martix to display the non-circular element

L(ismember(L, nonCircula_Matrix)) = 1;
L(ismember(L, circular_Matrix)) = 5;

figure, imshow(label2rgb(L, @jet, 'k'));
title(' Object Recognition');



% for k = 1 : length(B)
%     boundary = B{k};
%     % 显示白色边界
%     plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
% end

% hold on;
% % 确定圆形目标
% stats = regionprops(L,'Area','Centroid');
% % 设置求面积
% threshold = 0.85;
% for k = 1:length(B)
%     boundary = B{k};
%     delta_sq = diff(boundary).^2;
%     % 求周长
%     perimeter = sum(sqrt(sum(delta_sq,2)));
%     % 求面积
%     area = stats(k).Area;
%     metric = 4*pi*area/perimeter^2;
%     metric_string = sprintf('%2.2f', metric);
%     % 根据阈值匹配
%     if metric > threshold
%         centroid = stats(k).Centroid;
%         plot(centroid(1), centroid(2), 'ko');
%         text(centroid(1)-2, centroid(2)-2, '圆形', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
%     end
%     %     text(boundary(1,2)-10,boundary(1,1)-12, metric_string,'Color',...
%     %         'k','FontSize',14,'FontWeight','bold');
% end
% title('图像形状识别')





