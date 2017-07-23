function img = normalize(I,overlap, eyePosition)
    %% Rotate the image
    dy = eyePosition(4) - eyePosition(2);
    dx = eyePosition(3) - eyePosition(1);
    angle = atan(dy/dx);
    rotateCenter = [(eyePosition(1)+eyePosition(3))/2,...
        (eyePosition(2) + eyePosition(4))/2];
    
    img = rotateAround(I, rotateCenter(1), rotateCenter(2), angle);
    
    %% Scaling the image
    distance = sqrt(dx^2 + dy^2);
    scale= 75 / distance;
    img = imresize(img, scale);
    
    %% Cropping the image
    
    
    
    %% Cut the image
    xmod = mod(size(img,1),2*overlap);
    ymod = mod(size(img,2),2*overlap);
    img = img(1:size(img,1)-xmod,1:size(img,2)-ymod);

end