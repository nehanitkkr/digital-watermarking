
clc;
clear all;
close all;

%input watermark image
watermark = imread('copyright2.png');
%convert image to binary image
watermark = im2bw(watermark);
%resize image for watermarking
watermark = imresize(watermark ,[512 256]);
%display the secret image
figure;
imshow(watermark);
title('Secret Image');

%Visual Cryptography
[share1, share2] = VisCrypt(watermark);

%Outputs
figure;
imshow(share1);
title('Share 1');
figure;
imshow(share2);
title('Share 2');

imwrite(share1,'Share1.png');
imwrite(share2,'Share2.png');
