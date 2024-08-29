function f = front(c, m)

% c: cost functrions
% f: cost function fronts
% m: min or maximization indicators

n = size(c, 1); % npop
f = zeros(n, 2);
crnum = [1:n]';
f(:, 1) = crnum;
nrc = n; % number of remaining cromosomes
rc = crnum; % remaining cromosomes
i = 0; % front numbering


while nrc > 0 % build each front
    
    i = i + 1;
    f(rc(1), 2) = i;
    
    for j = 2:nrc % pick an individual from whole pop
       
        icr1 = rc(j);
        cr1 = c(icr1, :);
        front = f(f(:, 2) == i, 1);
        nfront = numel(front);
        mcr1 = 0;
        
        for k = 1:nfront % compare it to front members
            
            icr2 = front(k);
            cr2 = c(icr2, :);
            d = dominate(cr1, cr2, m);
            
            switch d
                case -1
                    mcr1 = mcr1 + 0;
                    f(icr2, 2) = i;
                case 0
                    mcr1 = mcr1 + 1;
                    f(icr2, 2) = i;
                case 1
                    mcr1 = mcr1 + 1;
                    f(icr2, 2) = 0;
            end
            
            if mcr1 == nfront
                f(icr1, 2) = i;
            else
                f(icr1, 2) = 0; 
            end
            
        end %
        
    end %
    
    
    rc = f(f(:, 2) == 0, 1);
    nrc = numel(rc);

end %
    
end


function d = dominate(f1, f2, m)

% nm = numel(m);
p1 = (f1 >= f2) == m;
p2 = (f1 > f2) == m;

if all(p1 == 0) || all(p2 == 0)
    d = -1;
elseif all(p1 == 1) || all(p2 == 1)
    d = 1;
else
    d = 0;
end

% sp1 = sum(p1);
% sp2 = sum(p2);
% sp11 = (sp1 - nm / 2) / (nm / 2);
% sp22 = (sp2 - nm / 2) / (nm / 2);
% sp = [sp11, sp22];
% asp1 = abs(sp11);
% asp2 = abs(sp22);
% asp = [asp1, asp2];
% [masp, im] = max(asp);
% d = floor(masp) * sp(im);

end