function pop = createrandomsolution (npop, id)

nvar = size(id, 2);

pop = zeros(npop, nvar);

for i = 1:nvar
   pop(:, i) = rand(npop, 1) .* (id(2, i) - id(1, i)) + id(1, i);
   
end

end