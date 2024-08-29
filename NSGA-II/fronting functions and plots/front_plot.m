clc
clear all
close all

m = [0 1 0];
c = unifrnd(0, 100, [100, 3]);
f = front(c, m);
mx = max(f(:, 2));
figure 

% plot(c(:, 1), c(:, 2), 'o');
plot3(c(:, 1), c(:, 2), c(:, 3), 'o');

hold on

lwa = linspace(4, 0.25, mx);

for i = 1:mx
    
    
    front = f(f(:, 2) == i, 1);
    [x, so] = sort(c(front, 1));
    y = c(front, 2);
    y = y(so);
    z = c(front, 3);
    z = z(so);
    
    % plot(x, y);
    plot3(x, y, z, 'o', 'LineWidth', lwa(i));
    
    
end