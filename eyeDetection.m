function eyePosition = eyeDetection(I)
    if size(I, 3) > 1
        I = rgb2gray(I);
    end
    
    fclose('all');
    imwrite(I, 'temp.jpg');
    
    fid = fopen('temp.jpg', 'r');
    imgData = char(fread(fid)');
    fclose(fid);
%     imgData = char(reshape(I,1,[]));
    
    key = '255cd858fefe42a8b1e7fea5318d6d5b';
    url = 'https://api.cognitive.azure.cn/face/v1.0/detect?returnFaceId=false&returnFaceLandmarks=true';
    
    headerFields = {'Ocp-Apim-Subscription-Key', key};
    headerFields{2,1} = 'Content-Length';
    headerFields{2,2} = string(length(imgData));
    headerFields = string(headerFields);


    options = weboptions;  
    options.MediaType = 'application/octet-stream';
    options.RequestMethod = 'post';
    options.HeaderFields = headerFields;  
    options.CharacterEncoding = 'ISO-8859-1';
    options.Timeout = 30;


    data = webwrite(url, imgData, options);

    left = data.faceLandmarks.pupilLeft;
    right = data.faceLandmarks.pupilRight;
    eyePosition = [left.x, left.y, right.x, right.y];
end