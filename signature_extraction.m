%% Signature extraction
function reconstructed_signature = signature_extraction(LLw_4, HHw_4, lengthOfWatermark)

% Select all coefficient from LL4 and HH4 band
% reshape them to row vectors of size 1x256
LLw_4 = reshape(LLw_4, 1, length(LLw_4)^2);
HHw_4 = reshape(HHw_4, 1, length(HHw_4)^2);

% concatenate the above row vectors into a larger row vector of size 1x512
combined = [LLw_4 HHw_4];

% keep record of the index position of negatives to put back the sign in
% reverse process
negative_index = combined(logical(combined)) < 0;

% keep only the positive integer parts
% separate the integer from the decimal fraction
combined_positive = abs(combined);
integer_part = fix(combined_positive);
fraction_part = abs(combined_positive - integer_part);


% Convert the integer part of selected coefficient into the binary code of L bits
binary_coefficients = {};
for y = 1:length(combined_positive)
    % binary_watermarked_coefficients{y} = bitget( uint16( integer_part_of_watermarked_image(y) ), 16:-1:1 );
    binary_coefficients{y} = decimalToBinaryVector(integer_part(y), 16);
end



% Extract the n-th (10-th) bit from the coefficient to extract the signature.
reconstructed_signature = zeros(1, lengthOfWatermark);
for u = 1:lengthOfWatermark
    for v = 1:16
        if (v == 10)
            reconstructed_signature(u) = binary_coefficients{1, u}(v);
        end
    end
end


end