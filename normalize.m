function img = normalize(I, overlap)
    
    %default parameters
    if nargin == 1
        overlap = 16;
    end

    img = I;
    for index = 1 : size(I, 3)
        if (size(img, 1) ~= 250 || size(img, 2) ~= 200)
            %% Rotate the image
            eyePosition = eyeDetection(I);
            
            dy = eyePosition(4) - eyePosition(2);
            dx = eyePosition(3) - eyePosition(1);
            angle = atan(dy/dx);
            rotateCenter = [(eyePosition(1)+eyePosition(3))/2,...
            (eyePosition(2) + eyePosition(4))/2];

            img = rotateAround(I, rotateCenter(1), rotateCenter(2), angle);

            %% Scaling the image
            eyePosition = eyeDetection(img);
            dy = eyePosition(4) - eyePosition(2);
            dx = eyePosition(3) - eyePosition(1);

            distance = sqrt(dx^2 + dy^2);
            scale= 75 / distance;
            img = imresize(img, scale);

            %% Cropping the image
            eyePosition = eyeDetection(img);
            eyeCenter = [(eyePosition(1)+eyePosition(3))/2,...
            (eyePosition(2) + eyePosition(4))/2];
            corner = [eyeCenter(1)-100,eyeCenter(2) - 115];
            img = imcrop(img, [corner(1), corner(2), 200, 250]);
        end
        %% Cut the image
        xmod = mod(size(img,1),2*overlap);
        ymod = mod(size(img,2),2*overlap);
        img = img(1:size(img,1)-xmod,1:size(img,2)-ymod);
        
    end

    
    
    

end