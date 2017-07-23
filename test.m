path = '..\Database\CUFS\sketch\f-039-01-sz1.jpg';
I = imread(path);
% I = rgb2gray(I);
%% Image normalizer

load('norCUFS.mat');
index = randi([1,100]);

subplot(1,2,1)
imshow(T(:,:,index * 2));
subplot(1,2,2)
imshow(T(:,:,index * 2 + 1));




% siftFeatures = featureExtraction(I, 'SIFT', 'csdn');
% mlbpFeatures = featureExtraction(I, 'MLBP', 'csdn');
%% Image Filter
% [dog, csdn, gau] = imageFiltering(I);

% subplot(1,3,1)
% imshow(dog);
% subplot(1,3,2)
% imshow(csdn)
% subplot(1,3,3)
% imshow(gau)

%% Represent image to patches

% [patches,nx,ny] = patching(I,16);
% img = combinePatch(patches, nx, ny);
% imshow(img)

%% Extract features
% siftFeatures = extractLBPFeatures(patches(:,:,1));
% [siftFeatures,~] = sift(I);
% mlbpFeatures = mlbp(I);
% 
% count = 0;
% for i = 1 : size(patches, 3)
%     [d,~] = sift(patches(:,:,i));
%     count = count + size(d,1);
% end