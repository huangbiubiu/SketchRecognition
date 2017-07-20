path = '..\Database\CUFS\photo\f1-001-01.jpg';
I = imread(path);
I = rgb2gray(I);
I = normalize(I,16);

%% Image Filter
[dog, csdn, gau] = imageFiltering(I);

% subplot(1,3,1)
% imshow(dog);
% subplot(1,3,2)
% imshow(csdn)
% subplot(1,3,3)
% imshow(gau)

%% Represent image to patches

[patches,nx,ny] = patching(I,16);
img = combinePatch(patches, nx, ny);
imshow(img)

%% Extract features
extractLBPFeatures(patches(:,:,1))
