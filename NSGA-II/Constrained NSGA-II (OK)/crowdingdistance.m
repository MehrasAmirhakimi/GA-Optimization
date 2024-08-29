function cd = crowdingdistance(c, f, m)

% c: cost functions
% f: cost function fronts
% m: min or maximization indicators

fnum = [1:size(f, 1)]';

if size(f, 2) == 1
    f = [fnum, f];
else
    f(:, 1) = fnum;
end

nc = size(c, 2);
cd = zeros(size(c));
nf = max(f(:, 2)) - min(f(:, 2)) + 1;
minf = min(f(:, 2));

for i = 1:nc
    
    for j = 1:nf
        
        fj = f(f(:, 2) == j-1+minf, 1);
        cf = c(fj, :);
        [sc, so] = sort(cf(:, i));
    
        if numel(sc) >= 3
            
            cd(fj(so(2:end-1)), i) = (sc(3:end) - sc(1:end-2)) / (sc(end)- sc(1));
            cd(fj(so(1 + m(i) * (end - 1))), i) = inf;
            % cd(fj(so( (1 - m(i)) * end + m(i) )), i) = cd(fj(so((1 - m(i)) * (end - 1) + m(i) *  2)));
            cd(fj(so( (1 - m(i)) * end + m(i) )), i) = inf;
            
        elseif numel(sc) == 2
            
            % cd(fj(so(1+m(i))), i) = inf;
            cd(fj, i) = inf;
            
        end
        
    end
    
end

cd = sum(cd, 2);