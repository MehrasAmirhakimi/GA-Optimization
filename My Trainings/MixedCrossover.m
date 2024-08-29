function [c1, c2] = MixedCrossover(p1, p2, id, gamma, ic, sdu)

VarMin = id(:, 1); % lower limit for a variable
VarMax = id(:, 2); % upper limit for a variable
BIC = id(:, 3); % B: binary (0), I: integer (1), C: continous (2)
nx = size(id, 1); % number of variables
nVar = id(:, 4); % number of bits each variable occupy
cumnVar = cumsum(nVar);
VarRange = zeros(nx, 2);
VarRange(1, 1) = 1;
VarRange(2:nx, 1) = cumnVar(1:nx-1) + 1;
VarRange(:, 2) = cumnVar;
[a1, a2] = ic;

c1 = p1;
c2 = p2;

for i = 1:nx
    
    vr = VarRange(i, 1) : VarRange(i, 2);
    a = rand;
    casenum = BIC(i);
    
    switch casenum
        case {0, 1}
            if a > a1
                [c1(vr), c2(vr)] = ix(p1(vr), p2(vr), sdu);
            end
        case 2
            if a < a2
                vmin = VarMin(i);
                vmax = VarMax(i);
                [c1(vr), c2(vr)] = cx(p1(vr), p2(vr), gamma);
                c1(vr) = min(c1(vr), vmax);
                c1(vr) = max(c1(vr), vmin);
                c2(vr) = min(c2(vr), vmax);
                c2(vr) = max(c2(vr), vmin);
            end
    end
        
end

end
