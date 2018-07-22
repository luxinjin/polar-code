function c = fFunction(a,b)
    c = sign(a).*sign(b).*min(abs(a),abs(b));
end