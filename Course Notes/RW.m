function out=RW(in)
s=[pop.cost];
s=1./s;
s=s/sum(s);
s=cumsum(s);
s=[0 s];
out=find(rand<=s,1,'first');
end