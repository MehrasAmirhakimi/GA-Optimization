function obj = Viennet(pop)

x = pop(:, 1);
y = pop(:, 2);

obj1 = 0.5 * (x.^2 + y.^2) + sin(x.^2 + y.^2);
obj2 = (3*x - 2*y + 4).^2 /8 + (x - y + 1).^2 / 27 + 15;
obj3 = 1./(x.^2 + y.^2 + 1) - 1.1 * exp(-(x.^2 + y.^2));

obj = [obj1, obj2, obj3];

end