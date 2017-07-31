function result = testing(dataset, bagSet, GPHI)
    % Set parameters
    gallerySize = size(GPHI, 2);
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
    
    % pre-extract all sketch features
    testingPreExtractedFeature = ...
        extractAllFeatures(dataset, 'display', false);
    
    % Recognition
    result = zeros(datasize, 2);
    for index = 1 : datasize
        %initialization
%         fprintf('Recognition: %d / %d\n',index,datasize);
        S = zeros(gallerySize, 6);% score with all testing gallery image
        probe = cell(6,1);
        for m = 1 : 6
            probe{m} = [];
            for bag = 1 : B
                mu = bagSet(bag).mu(m,:);
                sketchFeature = featureExtraction(index, m, m, bagSet(bag).kb,testingPreExtractedFeature);
                phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));

                W = bagSet(bag).W{m};
                probe{m} = [probe{m}, phiP' * W];

            end
        end
        for g = 1 : gallerySize
            for m = 1:6
                
                S(g,m) = S(g,m) + ...
                    dot(probe{m}, GPHI{m,g})/...
                    (norm(probe{m}).*norm(GPHI{m,g}));
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
%         fprintf('Result: %d %d',index, indexG);
        
    end
    
end