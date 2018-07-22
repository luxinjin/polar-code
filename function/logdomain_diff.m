function z=logdomain_diff(x,y)
%
% Usage:
%       z=logdomain_sum(x,y)
%
%   Perform difference of two real-numbers in logarithmic domain. The given two
%   numbers should already be in logarithmic domain. The natural logarithm
%   is used.
%       No argument check is performed to see if  x > y
%               x MUST be greater than y, and is assumed.
%
z = x + log1p(-exp(y-x));  % x+log(1 - exp(y-x)); efficient replacement
end
