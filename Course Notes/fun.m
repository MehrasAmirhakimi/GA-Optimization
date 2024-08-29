function cost=fun(X)
n=numel(X);
A=10;
cost=0;
for i=1:n
    cost=cost+X(i)^2-A*cos(2*pi*X(i));
end
cost=cost+A*n;
end