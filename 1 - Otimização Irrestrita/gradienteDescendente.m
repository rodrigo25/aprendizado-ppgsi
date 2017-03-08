% Rodrigo A. de Freitas Vieira - 7972578
% Gradiente Descendente

f = @(x1,x2) 2*(x1 - 2)^2 + 2*(x2 - 3)^2;

dfx1 = @(x1,x2) 4*(x1 - 2);
dfx2 = @(x1,x2) 4*(x2 - 3);

Gf = @(x1,x2) [dfx1(x1,x2); dfx2(x1,x2)];
Hf = [4 0; 0 4];

err = .00001;
alfa = .1;

xn = [0; 0];
xn1 = [8; 8];

k = 0;
values = [xn1];

while (abs(f(xn(1),xn(2))-f(xn1(1),xn1(2))) > err || k==0)
  xn = xn1;
  
  d = -Gf(xn(1),xn(2));
  
  if d == 0
    break
  end

  k = k+1;
  
  fprintf('iteracao: %d\n', k);
  
  alfa = metodoBissecao(alfa, xn, Gf, d);
  
  xn1 = xn + alfa * d;
  
  fprintf('xn:       %5.5f %5.5f\n', xn);
  fprintf('xn+1:     %5.5f %5.5f\n\n', xn1);
  values = [values xn1];
end;

ezcontour(f,[-8 12]);
hold on
plot(values(1,:),values(2,:),'-*black');

fprintf('\n\nresposta: %d --> %5.5f %5.5f\n', k, xn1);