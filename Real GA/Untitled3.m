clc
clear all
close all
Tsw = linspace(0, 120, 120);
xF = 0.02;
Hsw_plot = -0.033635409 + 4.207557011*Tsw - 6.200339e-4*Tsw.^2 + 4.459374e-6*Tsw.^3;
Hsw_2 = 1e-3*(- xF*(-2.348e4 + 3.152e5*xF + 2.308e6*xF^2 - 1.446e7*xF^3 + 7.826e3*Tsw - 4.417e1*Tsw.^2 + 2.139e-1*Tsw.^3 - 1.991e4*xF*Tsw + 2.778e4*xF^2*Tsw + 9.728e1*xF*Tsw.^2));
plot(Tsw, Hsw_plot + Hsw_2);