

# A Heterogeneous Face Recognition System

## Introduction
This is a command-line implementation of [1]. Database is [CUHK student data set](http://mmlab.ie.cuhk.edu.hk/archive/facesketch.html). 

According to [1], this algorithm can be used in variety of heterogeneous face, including near-infrared and thermal infrared, although only sketch face database is used to test, 

## Run
This system requires a MATLAB environment.

### Pre-process
Pre-processing includes 2 steps:
1. **Normalize each image in the database**
    1. This system use [Microsoft Cognitive Service](https://azure.microsoft.com/en-us/services/cognitive-services/) to detect eye position of the face, and normalize to a standard 200 * 250 pixels image. Due to Microsoft Cognitive Service is a RESTful API, Internet connection is required at this step. Related code can be seen in `eyeDetection.m`.
    2. After eye detection, a cropping is applied to the image to divide the image into small patches.
    3. Related code of this step is in `train.m`, and normalized images are saved in `norCUFS.mat`.
2. **Extract all feature descriptors**
    - The motivation of this step is to speed up the training step and testing step. In this step, features of all images are extracted and saved in `featureVectors.mat`. 
    - According to [1], 3 filters and 2 feature descriptors are applied to the image, which are *Difference of Gaussian* (dog), *Center-Surround Divisive Normalization* (csdn), *Gaussian smoothing filter* (gaussian) and *Scale-invariant Feature Transform* (SIFT), *Modified Local Binary Patterns* (MLBP), respectively.
    - Related function is `featureExtraction`.

### Training and testing
1. **Training**
    - As mentioned above, we use CUHK for training and testing. More specificly, 70% of the dataset are used for training, and 30% of the dataset are used for testing. A random subspace approach is applied according to [1].
    - Related code can be seen in `train.m`.
    - Training result is saved in `prototype.mat`.
2. **Testing**
    - 30% images of the database were used for testing the accuracy of the algorithm.

## Experiment result
The accuracy of the latest version is **73.3%**.

## Differences from the paper
1. The combination SIFT and DoG is abandoned due to it will cause an all zero feature descriptor vector.
2. In score level fusion, only scores using same descriptor were added. See section 5.4 in [1].

## Library used
- [VLFeat](www.vlfeat.org), a computer vision algorithm implementation on MATLAB. `vl_sift` is used to extract SIFT feature descriptors from images.
- [LDA](https://cn.mathworks.com/matlabcentral/fileexchange/29673-lda--linear-discriminant-analysis), a LDA implementation on MATLAB. 
- [RotateAround](https://cn.mathworks.com/matlabcentral/fileexchange/40469-rotate-an-image-around-a-point), a MATLAB function to rotate a image around a specfic point.

## Reference
[1] B. F. Klare and A. K. Jain, "Heterogeneous face recognition using kernel prototype similarities," IEEE Trans Pattern Anal Mach Intell, vol. 35, no. 6, pp. 1410-22, Jun 2013.