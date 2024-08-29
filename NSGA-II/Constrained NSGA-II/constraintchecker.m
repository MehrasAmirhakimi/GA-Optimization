function [isfeasible, sumviols] = constraintchecker(obj, cons)

if ~all(abs(cons(1, :) <= 1))
    return
end

[m, n] = size(obj);

viols = zeros(m, n);

for i = 1:n
    
    if cons(1, i) == -1
        viols(:, i) = max(0, obj(:, i)./cons(2, i) - 1);
    elseif cons(1, i) == 1
        viols(:, i) = max(0, 1 - obj(:, i)./cons(2, i));
    else
        viols(:, i) = abs(1 - obj(:, i)./cons(2, i));
    end

end

sumviols = sum(viols, 2);
isfeasible = sumviols == 0;

end