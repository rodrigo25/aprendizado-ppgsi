
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

l = [1 1];
B = [1 1 1 1 1];

ph1 = @(x1,x2) rh*( l(1)*(h1(x1,x2))^2 + l(2)*(h2(x1,x2))^2 );
ph2 = @(x1,x2) l(1)*h1(x1,x2) + l(2)*h2(x1,x2);
pg1 = @(x1,x2) rg*( max(g1(x1,x2),-B(1)/2*rg )^2 + max( g2(x1,x2),-B(2)/2*rg )^2 + max( g3(x1,x2),-B(3)/2*rg )^2 + max( g4(x1,x2),-B(4)/2*rg )^2 + max( g5(x1,x2),-B(5)/2*rg )^2 );
pg2 = @(x1,x2) max( g1(x1,x2),-B(1)/2*rg ) + max( g2(x1,x2),-B(2)/2*rg ) + max( g3(x1,x2),-B(3)/2*rg ) + max( g4(x1,x2),-B(4)/2*rg ) + max( g5(x1,x2),-B(5)/2*rg );
  
p = @(x1,x2) ph1(x1,x2) + pg1(x1,x2) + ph2(x1,x2) + pg2(x1,x2);

err = .000001;

values = [x];

x = gradienteDescendente(x,rh,rg,l,B);

values = [values x];

while(p(x(1),x(2)) > err || p(x(1),x(2)) < 0)
  rh = rh*Ch;
  rg = rg*Cg;
  
  l(1) = l(1) + 2*rh*h1(x(1),x(2));
  l(2) = l(2) + 2*rh*h2(x(1),x(2));
  
  B(1) = B(1) + 2*rg* max( g1(x(1),x(2)) , -B(1)/2*rg );
  B(2) = B(2) + 2*rg* max( g2(x(1),x(2)) , -B(2)/2*rg );
  B(3) = B(3) + 2*rg* max( g3(x(1),x(2)) , -B(3)/2*rg );
  B(4) = B(4) + 2*rg* max( g4(x(1),x(2)) , -B(4)/2*rg );
  B(5) = B(5) + 2*rg* max( g5(x(1),x(2)) , -B(5)/2*rg );
  
  x = gradienteDescendente(x,rh,rg,l,B);
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
title('Método de Lagrange Aumentado');
axis([0 4 0 4]);
grid;
hold off;
warning('on','MATLAB:ezplotfeval:NotVectorized');