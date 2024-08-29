function p = roulettewheel(cost, m)

%if m == 0
%    f = (1./cost)/sum(1./cost);
%else
%    f = cost/sum(cost);
%end

wc = max(cost);
f = exp(-cost/wc) ./ sum(exp(-cost/wc));

cumf = cumsum(f);
r = rand;
p = find(r <= cumf, 1, 'first');

end