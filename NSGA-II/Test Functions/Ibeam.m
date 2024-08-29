function f = Ibeam(pop)

% design variables (cromosome bits)

x1 = pop(:, 1);
x2 = pop(:, 2);
x3 = pop(:, 3);
x4 = pop(:, 4);


% properties and parameters

c = x4 + x3/2;
I = 1/12 * x1 .* x3 .^ 3 + 1/6 * x2 .* x4 .^ 3 + 1/2 * x2 .* x4 .* (x3 + x4) .^ 2;
L = 4;
P = 10^4;
M = P * L;
E = 200 * 10^9;
ro = 8000;


% objective functions

f1 = M * c ./ I; % maximum stress
f2 = P * L^3 ./ (3 * E * I); % maximum deflection
f3 = ro * L * (x1 .* x3 + 2 * x2 .* x4); % mass

% f = [f2, f3];
f = [f1, f2, f3];


% violations from constraints

%f10 = 250 * 10^6;
%f20 = 0.2;
%f30 = 1000;

%v1 = max(0, f1/f10 - 1);
%v2 = max(0, f2/f20 - 1);
%v3 = max(0, f3/f30 - 1);

%sumv = v1 + v2 + v3;


end