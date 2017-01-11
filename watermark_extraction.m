%% Watermark extraction
function watermark_logo_extracted = watermark_extraction(watermarked_image,watermark_logo ,  len,key,share2)

% Using Haar wavelet, decompose the watermarked image into four
% sub-bands: LL, HL, LH, and HH
[LLw HLw LHw HHw] = dwt2(watermarked_image, 'haar');

[LLw_1, HLw_1, LHw_1, HHw_1] = dwt2(LLw, 'haar');    % 1st step DWT
[LLw_2, HLw_2, LHw_2, HHw_2] = dwt2(LLw_1, 'haar');  % 2nd step DWT
[LLw_3, HLw_3, LHw_3, HHw_3] = dwt2(LLw_2, 'haar');  % 3rd step DWT
[LLw_4, HLw_4, LHw_4, HHw_4] = dwt2(LLw_3, 'haar');  % 4rth step DWT

[Uw_x Sw_x Vw_x] = svd(watermark_logo, 'econ');

%Generate signature using Uw & Vw matrices
generated_signature = signature_generation(Uw_x, Vw_x,key);

%Extract signature from LLw_4 & HHw_4 bands using all of the 512
%coefficients

reconstructed_signature = signature_extraction(LLw_4, HHw_4, len);

if ( reconstructed_signature == generated_signature | corr2(reconstructed_signature, generated_signature) > 0.1 )
        % proceed to watermark extraction if authentication is successful
        helpdlg('Authentication was successful!');
        % Apply SVD to HH band
        [Ucw Scw Vcw] = svd(HHw, 'econ');
        
        % Extract the singular values from HH band
        HH_singularValues = zeros(len);
        Shh_diag = diag(HH_singularValues);
        Scw_diag = diag(Scw);

        if (len >= 256)
            Shh_diag(1:length(Scw), :) = Scw_diag;
        elseif (len < 256)
            Shh_diag(1:len, :) = Scw_diag(1:len, :);
        end
        HH_singularValues(logical(eye(size(HH_singularValues)))) = Shh_diag;
        
        % Construct the watermark using singular values and orthogonal matrices
        % Uw and Vw obtained using SVD of original watermark
        watermark_logo_extracted = Uw_x * HH_singularValues * Vw_x';
        
        %display
        figure;
        subplot(2,2,1);
        imshow(watermark_logo_extracted, []);
        title('Extracted watermark');
        watermark_logo_extracted = uint8(watermark_logo_extracted);
        share2 = uint8(share2);
        share12 = bitor(watermark_logo_extracted , share2);
        figure;
        subplot(2,2,1);
        imshow(share12, []);
        title('original watermark');
else
        errordlg('Authetication Failure. The signatures do not match. No watermark extracted!');
        watermark_logo_extracted = zeros(length(watermark_logo), length(watermark_logo));
        return;
end
end