function f = FonsecaFleming(pop)

% global NFE
% NFE = NFE + 1;

n = size(pop, 2);

f1 = 1 - exp(-(sum((pop - 1/n^0.5).^ 2, 2)));
f2 = 1 - exp(-(sum((pop + 1/n^0.5).^ 2, 2)));

f = [f1, f2];

end