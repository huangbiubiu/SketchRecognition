function img = normalize(I,overlap)

    %% Cut the image
    xmod = mod(size(I,1),2*overlap);
    ymod = mod(size(I,2),2*overlap);
    img = I(1:size(I,1)-xmod,1:size(I,2)-ymod);

end