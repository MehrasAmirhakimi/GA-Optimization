function [y1, y2] = ux(x1, x2)

xlength = numel(x1);
mask = randi([0 1], [1 xlength]);
y1 = mask .* x1 + (1 - mask) .* x2;
y2 = mask .* x2 + (1 - mask) .* x1;

end