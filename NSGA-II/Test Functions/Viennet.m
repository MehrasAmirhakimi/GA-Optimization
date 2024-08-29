function f = Viennet(pop)

x = pop(:, 1);
y = pop(:, 2);

f1 = 0.5 * (x.^2 + y.^2) + sin(x.^2 + y.^2);
f2 = (3*x - 2*y + 4).^2 /8 + (x - y + 1).^2 / 27 + 15;
f3 = 1./(x.^2 + y.^2 + 1) - 1.1 * exp(-(x.^2 + y.^2));

f = [f1, f2, f3];

end