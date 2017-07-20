path = '..\Database\CUFS\sketch\f1-001-01-sz1.jpg';
I = imread(path);
% I = rgb2gray(I);
I = normalize(I,16);

featureExtraction(I, 'MLBP', 'csdn')
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