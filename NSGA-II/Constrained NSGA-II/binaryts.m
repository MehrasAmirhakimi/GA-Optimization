function c = binaryts(frontandcrowding)

npop = size(frontandcrowding, 1);
r = randsample(npop, 2);
tfc = frontandcrowding(r, :);

if tfc(1, 1) == tfc(2, 1)
    [~, ic] = max(tfc(:, 2));
else
    [~, ic] = min(tfc(:, 1));
end

c = r(ic);

end