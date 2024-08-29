function [y1,y2]=crossover(x1,x2,Xmin,Xmax)
alpha=unifrnd(-gamma,gamma+1,size(x1));
y1=alpha.*x1+(1-alpha).*x2;
y2=alpha.*x2+(1-alpha).*x1;
y1=min(y1,Xmax);
y1=max(y1,Xmin);
y2=min(y2,Xmax);
y2=max(y2,Xmin);
end