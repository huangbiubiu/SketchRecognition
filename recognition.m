function img = recognition(path, target)
    sketch = imread(path);
    if size(sketch, 3) ~= 1
        sketch = rgb2gray(sketch);
    end
    sketch = normalize(sketch, 16);
    
    load('trainingResult.mat');
    if strcmp(target, 'CUFS')
        load('GPhi.mat');
    else
        load('PRIPGPhi.mat');
    end
    
    [result, ~] = testing(sketch, bagSet, GPHI, T);
    result = result(2);
    img = gallerySet(:,:,result);
end