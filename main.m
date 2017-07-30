%% Load training data and extract features
dataset = loadData('dataset\training\');
dataset = normalize(dataset);

T = extractAllFeatures(dataset, 'display', true);

%% Training
bagSet = train(dataset, T, 'display', true);

%% Load testing data
gallerySet = loadData('dataset\testing\photos', false);
gallerySet = normalize(gallerySet);
T = extractAllFeatures(gallery, 'display', true);
GPHI = prepareGalleryData(bagSet, gallery, T);

%% Testing
probe = loadData('dataset\testing\sketches', false);
probe = normalize(probe);
result = testing(probe, bagSet, GPHI);