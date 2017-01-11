%Program for Construction of a (2,2) Visual Cryptography Scheme
function [share1, share2] = share_generator(watermark)
s = size(watermark);
share1 = zeros(s(1), (2 * s(2)));
share2 = zeros(s(1), (2 * s(2)));
%%White Pixels
s1a=[1 0];
s1b=[1 0];
[x,y] = find(watermark == 1);
len = length(x);
for i=1:len
    a=x(i);b=y(i);
    pixelShare=code_pixels(s1a,s1b);
    share1((a),(2*b-1):(2*b))=pixelShare(1,1:2);
    share2((a),(2*b-1):(2*b))=pixelShare(2,1:2);
end
%Black Pixels
s0a=[1 0];
s0b=[0 1];
[x,y] = find(watermark == 0);
len = length(x);
for i=1:len
    a=x(i);b=y(i);
    pixelShare=code_pixels(s0a,s0b);
    share1((a),(2*b-1):(2*b))=pixelShare(1,1:2);
    share2((a),(2*b-1):(2*b))=pixelShare(2,1:2);
end

