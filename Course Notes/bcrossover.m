function [y1,y2]=bcrossover(x1,x2)
n=numel(x1);
c=randi([1 n-1]);
y1=[x1(1:c) x2(c+1:n)];
y2=[x2(1:c) x1(c+1:n)];
end