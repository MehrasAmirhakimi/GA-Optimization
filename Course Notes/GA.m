it=100;
npop=50;
cr=0.8;
mu=0.05;
Xmin=[-5 -5 -5 -5];
Xmax=[5 5 5 5];
pop.pos=[];
pop.cost=[];
pop=repmat(pop,npop,1);
for i=1:npop
    pop(i).pos=unifrnd(Xmin,Xmax);
    pop(i).cost=fun(pop(i).pos);
end
costs=[pop.cost];
[costs,order]=sort(costs);
pop=pop(order);
nmut=ceil(mu*npop);
ncross=2*ceil(cr*npop/2);
