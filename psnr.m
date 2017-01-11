function p = psnr(x, y, vmax)

if nargin<3
    m1 = max( abs(x(:)) );
    m2 = max( abs(y(:)) );
    vmax = max(m1,m2);
end

d = mean( (x(:)-y(:)).^2 );

p = 10*log10( vmax^2/d );
end