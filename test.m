clear;
path = '..\Database\CUFS\sketch\f-039-01-sz1.jpg';
I = imread(path);
% I = rgb2gray(I);
%% Image normalizer

% load('norCUFS.mat');
% index = randi([1,100]);
% 
% subplot(1,2,1)
% imshow(T(:,:,index * 2));
% subplot(1,2,2)
% imshow(T(:,:,index * 2 + 1));




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

%% Test LDA
% Generate example data: 2 groups, of 10 and 15, respectively
% X = [randn(10,2); randn(15,2) + 1.5];  Y = [zeros(10,1); ones(15,1)];
% 
% % Calculate linear discriminant coefficients
% W = LDA(X,Y);
% W2 = W(:,2:end);
% 
% % Calulcate linear scores for training data
% L = [ones(25,1) X] * W';
% L2 = X * W2';
% % Calculate class probabilities
% P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
% P2 = exp(L2) ./ repmat(sum(exp(L2),2),[1 2]);

%% Test PCA
clear;
load('test.mat');
mu = NaN(6, nt);
j = 1;
[coeff, ~, latent, ~, ~, mu(j,:)] = pca(transpose(X(:,:,j)));
Xvar = sum(latent);
for element = 1 : size(latent, 1)
    if sum(latent(1:element))/Xvar > 0.99
        break;
    end
end
meancenterX = bsxfun(@minus, transpose(X(:,:,j)), mean(transpose(X(:,:,j)))); 
score = meancenterX * coeff(:,1:element);
Y = repmat(1:1:nt,2,1);
Y = Y(:);
Wmc = LDA(score, Y);
