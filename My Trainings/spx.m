function [y1, y2] = spx(x1, x2)

xlength = numel(x1);
cutp = randi([1, xlength - 1]);

y1 = [x1(1:cutp) x2(cutp+1:xlength)];
y2 = [x2(1:cutp) x1(cutp+1:xlength)];
end