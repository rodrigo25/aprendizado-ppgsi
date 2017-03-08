% Rodrigo A. de Freitas Vieira - 7972578
% Levenberg-Marquardt

f = @(x1,x2) 2*(x1 - 2)^2 + 2*(x2 - 3)^2;

r = @(x1,x2)[ (x1-2) ; (x2-3) ];

Gr = [1 0; 0 1];

Gf = @(x1,x2) Gr'*r(x1,x2);

xn = [0; 0];
xn1 = [8; 8];

alfa = 1;
err = .00001;
 
k = 0;
u = .02;

while (abs(f(xn(1),xn(2))-f(xn1(1),xn1(2))) > err)
  xn = xn1;
  
  d = -inv(Gr'*Gr + u*eye(2)) * Gr'*r(xn(1),xn(2));
  
  if d==0 
    break 
  end
  
  k = k+1;

  fprintf('iteracao: %d\n', k);
  
  alfa = metodoBissecao(alfa, xn, Gf, d);
  
  xn1 = xn + alfa * d;
  
  fprintf('xn:       %5.5f %5.5f\n', xn);
  fprintf('xn+1:     %5.5f %5.5f\n\n', xn1);
end;
fprintf('\n\nresposta: %d -> %5.5f %5.5f\n', k, xn1);