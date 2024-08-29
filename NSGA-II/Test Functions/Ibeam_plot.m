clc
close all
figure
hold on

pop1 = sortrows(initpop, 5);
x1 = pop1(:, 1);
x2 = pop1(:, 2);
x3 = pop1(:, 3);
x4 = pop1(:, 4);
x21 = x2 ./ x1;
x32 = x3 ./ x2;
x34 = x3 ./ x4;

plot3(x21(1:33), x32(1:33), x34(1:33), 'ro');



pop2 = sortrows(initpop, 6);
x1 = pop2(:, 1);
x2 = pop2(:, 2);
x3 = pop2(:, 3);
x4 = pop2(:, 4);
x21 = x2 ./ x1;
x32 = x3 ./ x2;
x34 = x3 ./ x4;
plot3(x21(1:33), x32(1:33), x34(1:33), 'b*');




xlabel('x2/x1');
ylabel('x3/x2');
zlabel('x3/x4');

axis([0 5 0 2 0 3]);

hold off