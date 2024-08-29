function i = TS (costs, m)

n = numel(costs);
slc = zeros(1, m);

for i = 1:m
    slc(i) = randi(n);
end

cs = costs(slc);
[~, q] = max(cs);
i = slc(q);

end