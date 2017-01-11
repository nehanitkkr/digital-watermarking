%DWT-SVD based watermarking
% clear workspace
clc;
clear all;
close all;


%change directory
folder_name = uigetdir(pwd, 'Select Directory Where the .m Files Reside');
if ( folder_name ~= 0 )
if ( strcmp(pwd, folder_name) == 0 )
    cd(folder_name);
end
else
return;
end

% read cover image & watermark logo
[cover_fname, cover_pthname] = ...
uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Cover Image');
if (cover_fname ~= 0)
cover_image = strcat(cover_pthname, cover_fname);
cover_image = double( rgb2gray( imread( cover_image ) ) );
cover_image = imresize(cover_image, [512 512], 'bilinear');
else
return;
end

[watermark_fname, watermark_pthname] = ...
uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Watermark Logo');
if (watermark_fname ~= 0)
watermark_logo = strcat(watermark_pthname, watermark_fname);
watermark_logo = ( im2bw( rgb2gray( imread( watermark_logo ) ) ) );
watermark_logo = imresize(watermark_logo, [512 256], 'bilinear');

figure;
imshow(watermark_logo);
title('watermark');
%Visual Cryptography
[share1, share2] = share_generator(watermark_logo);

%Outputs
figure;
imshow(share1);
title('Share 1');
figure;
imshow(share2);
title('Share 2');

else
return;
end
len = length(share1);
key = 1;
watermarked_images_dir = fullfile( pwd, 'watermarked_images\');   
[watermarked_image , Uw , Vw , len ]= watermark_embedding(cover_image, share1 ,key);
imwrite(uint8(watermarked_image), fullfile( watermarked_images_dir , strcat(num2str(key), '.png') ), 'png');

watermark_extraction(watermarked_image , share1 , len,key, share2);

attacks(len);














