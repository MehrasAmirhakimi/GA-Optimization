function f = Ackley(ppop, a, b, c)

d = size(ppop, 2);
f = -a * exp(-b * (1/d * sum(ppop .^ 2, 2)) .^ 0.5) - exp(1/d * sum(cos(c * ppop), 2)) + a + exp(1);


end