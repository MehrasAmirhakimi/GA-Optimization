function f = ZDT3(pop)

x1 = pop(:, 1);
x2 = pop(:, 2);

g = 1 + 9/29 * x2;
f1 = x1;
h = 1 - (f1 ./ g).^0.5 - (f1 ./ g) .* sin(10*pi*f1);
f2 = g .* h;

f = [f1, f2];


end