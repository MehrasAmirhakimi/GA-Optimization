function [isfeasible, sumviols] = TanakaCC(vars)

x = vars(:, 1);
y = vars(:, 2);
a = 0.1;
b = 16;

cfun = x.^2 + y.^2 - a*cos(b*atan(x ./ y));

viols = max(0, 1 - cfun);

sumviols = viols;
isfeasible = sumviols == 0;

end