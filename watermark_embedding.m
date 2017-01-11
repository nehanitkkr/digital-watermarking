%% Watermark Embedding
function [watermarked_image, Uw , Vw , len] = watermark_embedding(cover_image, share1,key)
len = length(share1);
% Apply Haar wavelet and decompose cover image into four sub-bands:
% LL, HL, LH, and HH
[LL, HL, LH, HH] = dwt2(cover_image, 'haar');


% Image intensity transformation
ca = wcodemat(LL);
ch = wcodemat(HL);
cv = wcodemat(LH);
cd = wcodemat(HH);
coded_image = [ca, ch; cv, cd];

% Plot one step decomposition
figure;
image(coded_image);
title('One step DWT decomposition');




% Apply SVD to HH (high frequency) band
[Uh Sh Vh] = svd(HH, 'econ');

% Watermark logo W is decomposed using SVD
[Uw Sw Vw] = svd(share1, 'econ');

% Replace singular values of the HH (high frequency) band with the
% singular values of the watermark
Sh_diag = diag(Sh);
Sw_diag = diag(Sw);

if (len >= 256)
    Sh_diag(1:length(Sh), :) = Sw_diag(1:length(Sh), :);        %genetic algorithm shall be used here
elseif(len < 256)
    Sh_diag(1:length(share1), :) = Sw_diag(1:length(share1), :);
end
Sh(logical(eye(size(Sh)))) = Sh_diag;

%generate signature using the orthogonal matrices of watermark
signature = signature_generation(Uw, Vw,key);

%embed the generated signature
LL_inv = signature_embedding(LL, signature);


% Apply SVD to obtain the modified HH band wich now holds the SV's of
% watermark logo
HH_modified = Uh * Sh * Vh';

% Apply inverse DWT with  HH(HH_modified) band to
% obtain the watermarked image
% Here the HH band should be the one modified with SV's
watermarked_image = idwt2(LL_inv, HL, LH, HH_modified, 'haar');

%display
figure;
subplot(2, 2, 1);
imshow(cover_image, []);
title('Cover image');
subplot(2, 2, 2);

imshow(watermarked_image, []);
title('Watermarked image');
subplot(2, 2, 3);
imshow(share1, []);
title('Watermark logo');




end

















