function loadData(database)
%loadData - Load data from database
%
% Syntax: loadData()

    if database == 'CUFS'
        
        sketchPath = '..\Database\CUFS\sketch';
        galleryPath = '..\Database\CUFS\photo';
        galleryFiles = dir(fullfile(galleryPath,'*.jpg'));
        garlleryExample = imread(fullfile(galleryPath, galleryFiles(1).name));
        sketchExample = imread(fullfile(sketchPath, ganame2skname(galleryFiles(1).name)));
        datasize = length(galleryFiles);

        galleryset = uint8(zeros(size(garlleryExample, 1), ...
                    size(garlleryExample, 2), ...
                    datasize));
        sketchset = uint8(zeros(size(sketchExample, 1), ...
                    size(sketchExample, 2), ...
                    datasize));
        
        for i = 1 : datasize
            filename = galleryFiles(i).name;
            galleryset(:,:,i) = rgb2gray(imread(fullfile(galleryPath,filename)));
            
            sketchimg = imread(fullfile(sketchPath,ganame2skname(filename)));
            if size(sketchimg, 3) ~= 1
                sketchset(:,:,i) = rgb2gray(sketchimg);
            else
                sketchset = sketchimg;
            end
        end

        save(strcat(database,'.mat'),'galleryset','sketchset');
    end

end

function filename = ganame2skname(galleryFileName)
    [~,filename,~] = fileparts(galleryFileName);
    filename = strcat(filename, '-sz1.jpg');
end