function feature = featureExtraction(I, featureType, filterType)
%featureExtraction - Extract SIFT or MLBP features
%
% Syntax: feature = featureExtraction(I, featureType, filterType)
%
% Extract features for each patches and concatenate them.
% Available feature type: 'MLBP' or 'SIFT'
% Available filter type: 'dog', 'csdn' or 'gaussian'
    
%% Filter    
    switch filterType
    case 'dog'
        [I,~,~] = imageFiltering(I);
    case 'csdn'
        [~,I,~] = imageFiltering(I);
    case 'gaussian'
        [~,~,I] = imageFiltering(I);        
    end

%% Split image to patches
    [patches,~,~] = patching(I, 16);

%% Extract features
    
    switch featureType
    case 'MLBP'
        feature = zeros(236,size(patches,3));
    case 'SIFT'
        feature = zeros(128,3*size(patches,3));
        k = 1;
    end

    for i = 1 : size(patches,3)
        switch featureType
        case 'MLBP'
            feature(:,i) = transpose(mlbp(patches(:,:,i)));
        case 'SIFT'
            [f,~] = sift(patches(:,:,i));
            num = size(f,1);
            feature(:,k:k+num-1) = transpose(f);
            k = k + num;
        end
    end
    
    if featureType == 'SIFT'
        feature = feature(:,1:k-1);
    end
    
%% Reshape feature matrix to a vector
    feature = reshape(feature, [], 1);
    
end