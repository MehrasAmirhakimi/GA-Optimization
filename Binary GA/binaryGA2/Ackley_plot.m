clc
clear all
close all

a = 5;
b = 0.05;
c = 4*pi;
d = 2;


x = linspace(-5, 5, 150);
y = linspace(-5, 5, 150);
[X, Y] = meshgrid(x, y);
f = -a * exp(-b * (1/d * (X.^2 + Y.^2)).^0.5) - exp(1/d * (cos(c * X) + cos(c * Y))) + a + exp(1);
surf(X, Y, f);
