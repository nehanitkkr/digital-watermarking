%% Signature embedding
function LL_inv = signature_embedding(LL, signature)

%  Using Haar wavelet, further decompose LL band to the 4th level.
[LL_1, HL_1, LH_1, HH_1] = dwt2(LL, 'haar');    % 1st step DWT
[LL_2, HL_2, LH_2, HH_2] = dwt2(LL_1, 'haar');  % 2nd step DWT
[LL_3, HL_3, LH_3, HH_3] = dwt2(LL_2, 'haar');  % 3rd step DWT
[LL_4, HL_4, LH_4, HH_4] = dwt2(LL_3, 'haar');  % 4rth step DWT


% Images coding.
ca = wcodemat(LL_4);
ch = wcodemat(HL_4);
cv = wcodemat(LH_4);
cd = wcodemat(HH_4);
coded_image = [ca, ch; cv, cd];


figure;
image(coded_image);
title('4-th step DWT decomposition');


% choose all in total 512 coefficients from LL_4 & HH_4
% reshape them to row vectors of size 1x256
LL_4 = reshape(LL_4, 1, length(LL_4)^2);
HH_4 = reshape(HH_4, 1, length(HH_4)^2);

% concatenate the above row vectors into a larger row vector of size 1x512
combined = [LL_4 HH_4];

% keep record of the index position of negatives to put back the sign in
% inverse process
negative_index = combined(logical(combined)) < 0;

% keep only the positive integer parts
% combined_LL4_and_HH4_coeff_posint = round( abs( combined_LL4_and_HH4_coef ) );

% separate the integer from the decimal fraction
combined_positive = abs(combined);
integer_part = fix(combined_positive);
fraction_part = abs(combined_positive - integer_part);

% Convert the integer part into the binary code of L=16 bits.
binary_coefficients = {};
for p = 1:length(integer_part)
    binary_coefficients{p} = decimalToBinaryVector(integer_part(p), 16);
end

% Replace the n-th bit (10th bit) position of the coefficient with
% signature bit
for m = 1:length(signature)
    for n = 1:16
        if (n == 10)
            binary_coefficients{1, m}(n) = signature(m);
        end
    end
end
% and then convert the binary code to its decimal representation
decimal_from_binary = zeros(1, length(binary_coefficients));
for x = 1:length(binary_coefficients)
    decimal_from_binary(x) = binaryVectorToDecimal(double(binary_coefficients{1, x}));
end

% reconstruct orignal array from integer and decimal fraction parts
% cmb_coef = integer_part + fraction_part;
decimal_from_binary = decimal_from_binary + fraction_part;

% put back the negative signs
decimal_from_binary(find(negative_index == 1)) = -decimal_from_binary(find(negative_index == 1));


% reshape the modified LL_4 & HH_4 sub-bands to their original size 16x16
% each
LL_4_modified = decimal_from_binary(1:256);
HH_4_modified = decimal_from_binary(257:end);
LL_4_modified = reshape(LL_4_modified, 16, 16);
HH_4_modified = reshape(HH_4_modified, 16, 16);


% Apply the inverse DWT with modified LL4 and HH4 band coefficients.
LL_3_inv = idwt2(LL_4_modified, HL_4, LH_4, HH_4_modified, 'haar');
LL_2_inv = idwt2(LL_3_inv, HL_3, LH_3, HH_3, 'haar');
LL_1_inv = idwt2(LL_2_inv, HL_2, LH_2, HH_2, 'haar');
LL_inv   = idwt2(LL_1_inv, HL_1, LH_1, HH_1, 'haar');


end