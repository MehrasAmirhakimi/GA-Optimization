% plotting fun1
clc
clear all
x = linspace(-20, 20, 500);
y = linspace(-20, 20, 500);
[X, Y] = meshgrid(x, y);
Z = fun1(X, Y);
contour(X, Y, Z);