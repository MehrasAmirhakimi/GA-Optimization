function [y1, y2] = cx(x1, x2, gamma)

alpha = unifrnd(-gamma, 1+gamma, size(x1));
y1 = alpha .* x1 + (1 - alpha) .* x2;
y2 = (1 - alpha) .* x1 + alpha .* x2;

end