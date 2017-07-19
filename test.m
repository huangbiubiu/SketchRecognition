path = '..\Database\CUFS\photo\f1-001-01.jpg';
I = imread(path);
I = rgb2gray(I);

[dog, csdn, gau] = imageFiltering(I);

subplot(1,3,1)
imshow(dog);
subplot(1,3,2)
imshow(csdn)
subplot(1,3,3)
imshow(gau)