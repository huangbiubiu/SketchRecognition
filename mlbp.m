function descriptors = mlbp(image)
    radii = [1,3,5,7];
    descriptors = zeros(length(radii),59);
    
    for r = 1:length(radii)
        descriptors(r,:) = ...
            extractLBPFeatures(image, 'Radius', radii(r));
    end
    
    descriptors = reshape(descriptors,1,[]);
end