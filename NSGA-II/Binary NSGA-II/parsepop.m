function ppop = parsepop(pop, id)

c = cumsum(id(1, :));
c1 = [0, c(1:end-1)] + 1;
c2 = c;
c = [c1', c2'];
nvar = size(id, 2);
ppop = zeros(size(pop, 1), nvar);

for i = 1:nvar
    
    bx = pop(:, c(i, 1):c(i, 2));
    rx = binary2real(bx);
    nb = size(bx, 2);
    rx = rx / (2^nb - 1) * (id(3, i) - id(2, i)) + id(2, i);
    ppop(:, i) = rx;
    
end

end

function rx = binary2real(bx)

l = size(bx, 2);
p1 = l-1:-1:0;
p2 = repmat(p1, [size(bx, 1), 1]);
p3 = 2 .^ p2;
p4 = bx .* p3;
rx = sum(p4, 2);

end