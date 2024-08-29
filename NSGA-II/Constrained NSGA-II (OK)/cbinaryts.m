function c = cbinaryts(fciv)

n = size(fciv, 1);
r = randsample(n, 2);
tfciv = fciv(r, :);
ti = sum(tfciv(:, 3));

switch ti
    
    case 2
        if tfciv(1, 1) == tfciv(2, 1)
            [~, ic] = max(tfciv(:, 2));
        else
            [~, ic] = min(tfciv(:, 1));
        end
        
    case 1
        [~, ic] = max(tfciv(:, 3));
        
    case 0
        [~, ic] = min(tfciv(:, 4));

end


c = r(ic);

end