function z=logdomain_sum(x,y)
% 
% Usage:
%       z=logdomain_sum(x,y)
% 
%   Perform sum of two real-numbers in logarithmic domain. The given two
%   numbers should already be in logarithmic domain. The natural logarithm
%   is used.
%

if(x<y)
    z = y+log1p(exp(x-y));  % y+log(1+exp(x-y)); efficient version
else
    z = x+log1p(exp(y-x));  % x+log(1+exp(y-x)); efficient version
end
end