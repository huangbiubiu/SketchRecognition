sketchpath = 'D:\OneDrive\Documents\Documents\Sketch\Database\PRIP\PRIP-HDC-Release\sketches';
gallerypath = 'D:\OneDrive\Documents\Documents\Sketch\Database\PRIP\PRIP-HDC-Release\photos';

filename = dir(fullfile(path));

for k = 1 : length(filename)
    name = 'MI_001.bmp';
    try
        sketch = imread(fullfile(sketchpath, name));
        galleryimg = imread(fullfile(gallerypath, name));

        if size(sketch, 3) ~= 1
            sketch = rgb2gray(sketch);
        end
        if size(galleryimg, 3) ~= 1
            galleryimg = rgb2gray(galleryimg);
        end
        
        sketch = normalize(sketch, 16, 'iscut',false);
        galleryimg = normalize(galleryimg, 16, 'iscut',false);

    %     subplot(1,2,1)
    %     imshow(sketch)
    %     subplot(1,2,2)
    %     imshow(galleryimg)
        
        [~,name,~] = fileparts(name);
        name = strcat(name, '.jpg');
        imwrite(sketch,fullfile(sketchpath, name));
        imwrite(galleryimg,fullfile(gallerypath, name));
        fprintf('%s completed.\n', name);
    catch
        fprintf('%s failed.\n',name);
    end
end
