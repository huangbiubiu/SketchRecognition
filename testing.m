function result = testing(dataset, bagSet, gallery, preExtractedFeature)
    % arguments checking
    if size(gallery, 3) ~= size(preExtractedFeature, 3)
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
                dataset = bagSet(bag).T{m}(:,2:2:end);
                W = bagSet(bag).W{m};
                phi = similarity(galleryFeatures{m, k, bag}, dataset);
                GPHI{m, k} = [GPHI{m, k}, phi' * W];
            end
        end
    end
    
    % Recognition
    result = zeros(datasize, 2);
    for index = 1 : datasize       
        %initialization
        S = zeros(gallerySize, 6);% score with all testing gallery image

        for g = 1 : gallerySize
            for m = 1:6
                    probe = [];
                for bag = 1 : B
                    kb = bagSet(bag).kb;
                    mu = bagSet(bag).mu(m,:);

                    sketchFeature = featureExtraction(dataset(:,:,index), m, m, bagSet(bag).kb);
                    phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));

                    W = bagSet(bag).W{m};
                    probe = [probe, phiP' * W];

                end
                S(g,m) = S(g,m) + ...
                    dot(probe, GPHI{m,g})/...
                    (norm(probe).*norm(GPHI{m,g}));
        %         fprintf('%d. g = %d, m = %d.\n',(norm(probe).*norm(GPHI{m,g})),g,m);
            end
        end

        % normalize S
        for m = 1 : 6
            S(:,m) = (S(:,m) - min(S(:,m))) / (max(S(:,m)) - min(S(:,m)));
        end
        S = S(:,[1:3 5:6]);%abandon the combination of SIFT and DoG
        S = sum(S, 2);

        [~, indexG] = max(S);
        
        result(index,:) = [index, indexG];

    end
    
end