function [y1, y2] = dpx(x1, x2)

xlength = numel(x1);
cutp = randsample(xlength -1, 2);
c1 = min(cutp);
c2 = max(cutp);

y1 = [x1(1:c1) x2(c1+1:c2) x1(c2+1:xlength)];
y2 = [x2(1:c1) x1(c1+1:c2) x2(c2+1:xlength)];

end