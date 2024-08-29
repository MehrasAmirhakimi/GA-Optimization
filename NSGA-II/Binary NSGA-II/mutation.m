function y = mutation(x, mu)

if mu == 0
    nm = 1;
else
    nm = ceil(mu * numel(x));
end

mp = randsample(numel(x), nm);
y = x;
y(mp) = 1 - x(mp);

end