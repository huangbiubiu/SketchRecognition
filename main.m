%% Read in all training data

%% Normalize

%% Extract features

for i = 1 : 2 * nt
    T(:,:,i) = featureExtraction(T(:,:,i), 'MLBP', 'csdn');
end

%% Represent prototype

X = prototypeRepresentation(T);

%% Discriminant analysis

W1 = pca(X);
meancenterX = X-repmat(mean(X),size(X,1),1); %uncertain
[SW SB] = scattermat(transpose(W1)*meancenterX);
[~,~,W2] = eig(transpose(inv(SW)*SB));
W = W1 * W2;
mu = mean(X, 2);