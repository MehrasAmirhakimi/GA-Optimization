function i = RWS (fitness)

w = cumsum(fitness);
r = rand;
i = find(w >= r, 1, 'first');

end