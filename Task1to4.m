clc; clear; close all;

%% Task 1: Pre-processing -----------------------
% Step-1: Load input image
imageOriginal = imread('IMG_01.jpg');
figure, imshow(imageOriginal)
title('Load original image');

% Step-2: Covert image to grayscale
imageGray = rgb2gray(imageOriginal);
figure, imshow(imageGray)
title('Covert Image to Grayscale');

% Step-3: Rescale image
imageResize = myResize_Bili_Inter(imageGray, 0.5, 0.5);
figure,imshow(imageResize) % Grey-scale image
title('Rescale Grey-Scale Image');

% Step-4: Produce histogram· before enhancing
img_hist = imageResize(:,:,1);
figure, imhist(img_hist);  % Plot the histogram
title('Plot Histogram by histeq')


% Step-5: Enhance image before binarisation
% Contrast Adjustment

img_enhance = imadjust(imageResize);
figure, imshow(img_enhance)
title('Enhance Image by imadjust')

% I = double(imageResize);
% noise_img = (I - 85) * 255 / 75;
% row = size(I, 1);
% col = size(I, 2);
% 
% for i = 1 : row
%     for j = 1: col
%         if noise_img(i, j) < 0
%             noise_img(i, j) = 0;
%         end
%         
%         if noise_img(i, j) > 255
%             noise_img(i, j) = 255;
%         end
%     end
% end
% 
% img_enhance1 = uint8(noise_img);
% figure, imshow(img_enhance1);


% Step-6: Histogram after enhancement
img_enhanceHist = img_enhance(:,:,1);
imhist(img_enhanceHist);  % Plot the histogram
title('Histogram after Enhancement')


% Step-7: Image Binarisation
image_Binarization = imbinarize(img_enhance, 0.16);       %对图像二值化
figure, imshow(image_Binarization)
title('Binary Version of Image')


%% Task 2: Edge detection ------------------------
% myEdge_detect(image_Binarization);

% double_precision  = im2double(imageResize);  % Converting images to double precision values
% noise_img = imnoise(double_precision , 'gaussian', 0.45, 0);
% [edge_img, thresh] = edge(noise_img, 'canny');
% figure, imshow(edge_img);
% title('canny');


img = imageResize;
[m, n] = size(img);
img=double(img);

%%canny边缘检测的前两步相对不复杂，所以我就直接调用系统函数了
%%高斯滤波
w=fspecial('gaussian',[5 5]);
img=imfilter(img,w,'replicate');
% figure, imshow(uint8(img))

%%sobel边缘检测
w=fspecial('sobel');
img_w=imfilter(img,w,'replicate');      %求横边缘
w=w';
img_h=imfilter(img,w,'replicate');      %求竖边缘
img=sqrt(img_w.^2+img_h.^2);        %注意这里不是简单的求平均，而是平方和在开方。我曾经好长一段时间都搞错了
% figure, imshow(uint8(img))

%%下面是非极大抑制
new_edge=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        Mx=img_w(i,j);
        My=img_h(i,j);
        
        if My~=0
            o=atan(Mx/My);      %边缘的法线弧度
        elseif My==0 && Mx>0
            o=pi/2;
        else
            o=-pi/2;
        end
        
        %Mx处用My和img进行插值
        adds=get_coords(o);      %边缘像素法线一侧求得的两点坐标，插值需要
        M1=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3));   %插值后得到的像素，用此像素和当前像素比较
        adds=get_coords(o+pi);  %边缘法线另一侧求得的两点坐标，插值需要
        M2=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3));   %另一侧插值得到的像素，同样和当前像素比较
        
        isbigger=(Mx*img(i,j)>M1)*(Mx*img(i,j)>=M2)+(Mx*img(i,j)<M1)*(Mx*img(i,j)<=M2); %如果当前点比两边点都大置1
        
        if isbigger
            new_edge(i,j)=img(i,j);
        end
    end
end
% figure, imshow(uint8(new_edge))

%%下面是滞后阈值处理
up = 80;     %上阈值
low = 55;    %下阈值
set(0,'RecursionLimit',10000);  %设置最大递归深度
for i=1:m
    for j=1:n
      if new_edge(i,j)>up &&new_edge(i,j)~=255  %判断上阈值
            new_edge(i,j)=255;
            new_edge=connect(new_edge,i,j,low);
      end
    end
end

edge_img = (new_edge==255);
figure, imshow(edge_img);



%闭运算在数学上是先膨胀再腐蚀的结果
%闭运算的物理结果也是会平滑对象的轮廓，但是与开运算不同的是，闭运算
%一般会将狭窄的缺口连接起来形成细长的弯口，并填充比结构元素小的洞
se = strel('disk', 9');%圆盘型结构元素
foc = imclose(edge_img, se);%先开后闭运算
figure, imshow(foc);
title('先开后闭运算');


%开运算数学上是先腐蚀后膨胀的结果
%开运算的物理结果为完全删除了不能包含结构元素的对象区域，平滑
%了对象的轮廓，断开了狭窄的连接，去掉了细小的突出部分
se = strel('disk', 3'); %圆盘型结构元素
fo = imopen(foc, se);%直接开运算
figure, imshow(fo);
title('直接开运算');





%% Task 3: Simple segmentation --------------------

I = im2double(fo);
T = graythresh(I);
J = im2bw(I, T);

figure, imshow(J);

% T = graythresh(fo);                          % 自动获取阈值
% T = T * 205;                                  % 阈值在区间[0,1]，需调整至[0,255]
% g = imageGray<=T;
% figure, imshow(g);
% title(['阈值处理,阈值为' num2str(T)]);


%% Task 4: Object Recognition --------------------

