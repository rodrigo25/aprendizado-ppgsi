
f  = @(x1,x2) (x1 - 2)^4 + (x1 - 2*x2)^2;

h1 = @(x1,x2) x1^2 - x2;
h2 = @(x1,x2) (x1 - 2)^2 + (x2 - 2)^2 - 1;

g1 = @(x1,x2) x1^2 + x2 - 4;

g2 = @(x1,x2) x1-4;
g3 = @(x1,x2) -x1;
g4 = @(x1,x2) x2-4;
g5 = @(x1,x2) -x2;

x = [3;3];

Ch = 5;
Cg = 5;

rh = 1;
rg = 1;

p = @(x1,x2) rh*( (h1(x1,x2))^2 + (h2(x1,x2))^2 ) + rg*( max(0,g1(x1,x2))^2 + max(0,g2(x1,x2))^2 + max(0,g3(x1,x2))^2 + max(0,g4(x1,x2))^2 + max(0,g5(x1,x2))^2);

err = .000001;

values = [x];

x = gradienteDescendente(x,rh,rg);

values = [values x];

while(p(x(1),x(2))>= err)
  rh = rh*Ch;
  rg = rg*Cg;
  %k = k + 1;
  
  x = gradienteDescendente(x,rh,rg);
  values = [values x];
end

warning('off','MATLAB:ezplotfeval:NotVectorized');
h_1 = ezplot(h1);
set(h_1,{'Linewidth','Color'},{2,'blue'});
hold on
h_2 = ezplot(h2);
set(h_2,{'Linewidth'},{2});
hold on
g1_2 = ezplot(g1);
hold on
plot(values(1,:),values(2,:),'-*black');
set(g1_2,{'Linewidth','Color'},{2,'red'});
title('Método da Penalidade');
axis([0 4 0 4]);
grid;
hold off;
warning('on','MATLAB:ezplotfeval:NotVectorized');