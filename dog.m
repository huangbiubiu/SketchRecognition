function dogimg = dog(img, sigma1, sigma2)
    GaussKernel = 3;
    
    GaussFilt1 = fspecial('Gaussian', GaussKernel, sigma1);
    GaussFilt2 = fspecial('Gaussian', GaussKernel, sigma2);
    
    DiffGauss = GaussFilt2 - GaussFilt1;
    dogimg(:,:) = conv2(double(img), DiffGauss, 'same');

end