function GPHI = prepareGalleryData(bagSet, gallery, preExtractedFeature)
    % arguments checking
    if size(gallery, 3) ~= size(preExtractedFeature{1}, 2)
        throw(MException('testing: illegal arguments',...
            'the gallery and preExtractedFeature should be same size'));
    end

    % Set parameters
    gallerySize = size(gallery, 3);
    datasize = size(dataset, 3);
    B = 30;
    alpha = 0.1;
    
    WLength = zeros(B, 6);
    for bag = 1 : B
        for m = 1 : 6
            WLength(bag, m) = size(bagSet(bag).W{m},2);
        end
    end
    PHILength = transpose(sum(WLength, 1));
    
    % extract gallery features
    galleryFeatures = cell(6,gallerySize,B);
    for k = 1 : gallerySize
        for m = 1 : 6
            for bag = 1 : B
                galleryFeatures{m, k, bag} = ...
                    featureExtraction(k, m, m, bagSet(bag).kb, preExtractedFeature);
            end
        end
    end
    
    % Compute PHI of each gallery image
    GPHI = cell(6,gallerySize);
    for m = 1 : 6
        for k = 1 : gallerySize
            for bag = 1 : B
                galleryFeatureSet = bagSet(bag).T{m}(:,2:2:end);
                W = bagSet(bag).W{m};
                phi = similarity(galleryFeatures{m, k, bag}, galleryFeatureSet);
                GPHI{m, k} = [GPHI{m, k}, phi' * W];
            end
        end
    end
end