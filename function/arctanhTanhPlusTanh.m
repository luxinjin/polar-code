function c = arctanhTanhPlusTanh(a,b)
    c = 2*atanh(tanh(a/2)*tanh(b/2));
end