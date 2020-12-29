% Task 5: Robust method --------------------------

% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT)
