function [y1, y2] = crossover(x1, x2, sdu)

p = roulettewheel(sdu, 1);

switch p
    case 1
        [y1, y2] = singlepointcrossover(x1, x2);
    case 2
        [y1, y2] = doublepointcrossover(x1, x2);
    case 3
        [y1, y2] = uniformcrossover(x1, x2);
end


end

function [y1, y2] = singlepointcrossover(x1, x2)

cp = randi([1, numel(x1)-1]);

y1 = [x1(1:cp), x2(cp+1:end)];
y2 = [x2(1:cp), x1(cp+1:end)];

end

function [y1, y2] = doublepointcrossover(x1, x2)

cp = randsample(numel(x1)-1, 2);
c1 = min(cp);
c2 = max(cp);

y1 = [x1(1:c1), x2(c1+1:c2), x1(c2+1:end)];
y2 = [x2(1:c1), x1(c1+1:c2), x2(c2+1:end)];

end

function [y1, y2] = uniformcrossover(x1, x2)

mask = randi([0, 1], size(x1));
y1 = mask .* x1 + (1-mask).*x2;
y2 = mask .* x2 + (1-mask) .*x1;

end