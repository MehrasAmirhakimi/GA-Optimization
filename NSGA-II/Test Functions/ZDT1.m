function f = ZDT1(pop)

n = size(pop, 2);
g =  1 + 9 * sum(pop(:, 2:end), 2) / (n - 1);
f1 = pop(:, 1);
f2 = g .* (1 - (pop(:, 1) ./ g) .^ 0.5);
f = [f1, f2];

end