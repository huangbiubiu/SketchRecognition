%% Load training data and extract features
dataset = loadData('dataset\training\');
dataset = normalize(dataset);

T = extractAllFeatures(dataset, 'display', true);

%% Training
bagSet = train(dataset, T, 'display', true);

%% Load testing data
% load('temp.mat')
dataset = loadData('dataset\testing\');
dataset = normalize(dataset);

probe = dataset(:,:,1:2:end);
gallery = dataset(:,:,2:2:end);

T = extractAllFeatures(gallery, 'display', true);
GPHI = prepareGalleryData(bagSet, gallery, T);

result = testing(probe, bagSet, GPHI);